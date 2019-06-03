//
//  HttpRequestAble.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/6.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

typealias ResponseInfo<T: Decodable> = (error: String?, data: T?)

protocol HttpRequestAble: CreateRequestAble {
    
}

private let timeout: TimeInterval = 25

extension HttpRequestAble {
    
    func getJson<T: APIBaseResponse>(url: String,
                                     param: [String:Any]? = nil,
                                     timeout: TimeInterval = timeout,
                                     isLogin: Bool = false) -> Observable<APIResult<T>> {
        return self.requestJson(url: url, method: .get, param: param, timeout: timeout,
                                isLogin: isLogin)
    }
    
    func postJson<T: APIBaseResponse>(url:String,
                                      param: [String:Any]? = nil,
                                      timeout: TimeInterval = timeout,
                                      isLogin: Bool = false) -> Observable<APIResult<T>> {
        return self.requestJson(url: url, method: .post, param: param, timeout: timeout,
                                isLogin: isLogin)
    }
    
    private func requestJson<T: APIBaseResponse>(url: String,
                                                 method: HTTPMethod,
                                                 param: [String:Any]? = nil,
                                                 timeout: TimeInterval = timeout,
                                                 isLogin: Bool = false) -> Observable<APIResult<T>> {
        return Observable.create { (ob) -> Disposable in
            self.createRequest(url: url, param: param, method: method, timeout: timeout).responseEncodingJson(completionHandler: { (responseData) in
                let result: APIResult<T> = self.converAPI(responseData)
                guard isLogin else {
                    if result.isInvalid {//token过期退出登录
                        NotificationCenter.default.post(name: NotificationName.userSignOut.rawValue, object: nil)
                    }
                    ob.onNext(result)
                    return
                }
                ob.onNext(result)
            })
            return Disposables.create()
        }
    }
    
    func getJson(url: String,
                 param: [String:Any]? = nil,
                 timeout: TimeInterval = timeout,
                 success:@escaping (([String: Any]) -> ()),
                 fail:@escaping ((String) -> ())) {
        
        let formatedParam = param ?? [String:Any]()
        self.createRequest(url: url, param: formatedParam, method: .get, timeout: timeout).responseEncodingJson { (responseData) in
            let result = responseData.result
            let data = responseData.data
            let error = result.error
            let response = try? JSONSerialization.jsonObject(with: data ?? Data(), options: JSONSerialization.ReadingOptions.mutableContainers)
            Logger.debug(" ============ http response ============", " url: \(String(describing: responseData.request?.url))", " response: ", (response) ?? [String : Any](),"============ http response ============")
            if let error = error {//网络错误
                Logger.debug(error)
                fail("网络异常，请检查网络设置")
            }else {
                do {
                    if let response = try JSONSerialization.jsonObject(with: data ?? Data(), options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                        success(response)
                    }
                } catch {
                    fail("服务器异常，请稍后再试")
                    Logger.debug(" ============ http response ============", " url: \(String(describing: responseData.request?.url))", " response parsing failed", "============ http response ============")
                }
            }
            
        }
    }
}

extension HttpRequestAble {
    
    
    
    func converAPI<T: APIBaseResponse>(_ responseData: DataResponse<Any>) -> APIResult<T> {
        
        let result = responseData.result
        let data = responseData.data
        let error = result.error
        do {
            let response = try JSONSerialization.jsonObject(with: data ?? Data(), options: JSONSerialization.ReadingOptions.mutableContainers)
            Logger.debug(" ============ http response ============", " url: \(String(describing: responseData.request?.url))", " response: ", (response) , "============ http response ============")
        } catch {
            Logger.debug(" ============ http response ============", " url: \(String(describing: responseData.request?.url))", " response parsing failed", "============ http response ============")
        }
        if let error = error {//网络错误
            Logger.debug(error)
            return APIResult.fail(error: APIError.netWorkError)
        }else {
            if let data = data {
                let resultData = T.instance(with: data)
                if let resultData = resultData {
                    return APIResult.success(data: resultData)
                }else{//解析数据失败
                    return APIResult.fail(error: APIError.remoteServerError())
                }
            } else {//未知错误
                return APIResult.fail(error: APIError.remoteServerError(code: -999, message: "未知错误"))
            }
        }
        
        
    }
    
}

protocol CreateRequestAble {
    
}

extension CreateRequestAble {
    
    func createRequest(url:String,
                       param:Dictionary<String,Any>? = nil,
                       method:HTTPMethod = .post,
                       timeout:TimeInterval = timeout) -> DataRequest {
        let formatedParam = param ?? [String:Any]()
        Logger.debug(" ============ http request ============", " url:\(url)", " method:\(method) ", " param:", (formatedParam), "============ http request ============")
        let manager = SessionManager.default
        let dataRequest : DataRequest!
        do{
            var reqs = try URLRequest(url: url, method: method)
            reqs.timeoutInterval = timeout
            //JSONEncoding
            if method == .post {
                let encodedURLRequest = try JSONEncoding.default.encode(reqs, with: formatedParam)
                dataRequest = manager.request(encodedURLRequest)
            } else {
                let encodedURLRequest = try URLEncoding.default.encode(reqs, with: formatedParam)
                dataRequest = manager.request(encodedURLRequest)
            }
        }catch{
            dataRequest = manager.request(url, method: method, parameters: formatedParam)
        }
        return dataRequest
    }
    
}
