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

protocol HttpRequestAble {

}

private let timeout: TimeInterval = 40

extension HttpRequestAble {
    

    func getJson<T:APIResult>(url:String,
                 param:[String:Any]? = nil,
                 timeout:TimeInterval = timeout) -> Observable<APIResponse<T>> {
        return Observable.create { (ob) -> Disposable in
            self.createRequest(url: url, param: param, method: .get, timeout: timeout).responseEncodingJson(completionHandler: { (responseData) in
                ob.onNext(self.converAPI(responseData))
            })
            return Disposables.create()
        }
    }
    
    func postJson<T:APIResult>(url:String,
                 param:[String:Any]? = nil,
                 timeout:TimeInterval = timeout) -> Observable<APIResponse<T>> {
        return Observable.create { (ob) -> Disposable in
            self.createRequest(url: url, param: param, method: .post, timeout: timeout).responseEncodingJson(completionHandler: { (responseData) in
                ob.onNext(self.converAPI(responseData))
            })
            return Disposables.create()
        }
    }
    
    private func reloginResult<T: APIResult>(with responseData: T?) -> Observable<APIResponse<T>> {
        let code = responseData?.returnCode
        if code == "00" {
            Logger.debug("---------session 更新完毕 开始重新发送请求---------")
            return Observable.of(APIResponse.success(data: responseData!))
        } else if code == "111" || code == "-2" {
            Logger.debug("---------token 过期!---------");
//            AccountStore.invalid(withNotification: false)
            return Observable.of(APIResponse.fail((code: .unknownErrorCode, msg: "登录已过期，请重新登录")))
        } else {
            Logger.debug("---------session 更新发生错误---------");
            return Observable.of(APIResponse.fail((code: .unknownErrorCode, msg: "登录状态错误，请稍后再试")))
        }
    }
    
    func getJsonNeedLogin<T: APIResult>(url:String,
                  param:[String:Any]? = nil,
                  timeout:TimeInterval = timeout) -> Observable<APIResponse<T>> {
//        let accountStore = AccountStore.current()
//        if accountStore.loginType == .none {
//            Logger.debug("用户未登录");
//        }
        let jsessionid = ""//accountStore.sessionId
        let sessionFormatedUrl = url.appending(";jsessionid=" + jsessionid)
        
        return self.getJson(url: sessionFormatedUrl, param: param, timeout: timeout).flatMap({ (response) -> Observable<APIResponse<T>> in
//            if response.isloginDateOut {
                let api = SingletonFactory.getInstance(classType: ImpleAppNodeAPI.self)
//                return api.reSiginAndUpdateAccount(param: BossSiginParam.defaultParam()).flatMap({ (response) -> Observable<APIResponse<T>> in
//                    return self.reloginResult(with: response.data as? T).flatMap({ (result) -> Observable<APIResponse<T>> in
//                        if result.isSuccess {
//                            return self.getJson(url: sessionFormatedUrl, param: param, timeout: timeout)
//                        } else {
//                            return Observable.of(result)
//                        }
//                    })
//                })
//            } else {
                return Observable.of(response as! APIResponse<T>)
//            }
        })
        
    }
    
    func postJsonNeedLogin<T: APIResult>(url:String,
                           param:[String:Any]? = nil,
                           timeout:TimeInterval = timeout) -> Observable<APIResponse<T>> {
        
//        let accountStore = AccountStore.current()
//        if accountStore.loginType == .none {
//            Logger.debug("用户未登录");
//        }
        let jsessionid = ""//accountStore.sessionId
        let sessionFormatedUrl = url.appending(";jsessionid=" + jsessionid)
        
        return self.postJson(url: sessionFormatedUrl, param: param, timeout: timeout).flatMap({ (response) -> Observable<APIResponse<T>> in
//            if response.isloginDateOut {
                let api = SingletonFactory.getInstance(classType: ImpleAppNodeAPI.self)
                //                return api.reSiginAndUpdateAccount(param: BossSiginParam.defaultParam()).flatMap({ (response) -> Observable<APIResponse<T>> in
                //                    return self.reloginResult(with: response.data as? T).flatMap({ (result) -> Observable<APIResponse<T>> in
                //                        if result.isSuccess {
                //                            return self.getJson(url: sessionFormatedUrl, param: param, timeout: timeout)
                //                        } else {
                //                            return Observable.of(result)
                //                        }
                //                    })
                //                })

//            } else {
                return Observable.of(response as! APIResponse<T>)
//            }
        })
    }
}

extension HttpRequestAble {
    
    func converAPI<T: APIResult>(_ responseData:DataResponse<Any>) -> APIResponse<T> {
        
        let result = responseData.result
        let data = responseData.data
        let error = result.error
        if let error = error{
            Logger.debug(error)
            return APIResponse.fail((code: .internetError ,msg: error.localizedDescription))
        }else{
            if let data = data {
                let resultData = try? JSONDecoder().decode(T.self, from: data)
                if let resultData = resultData {
                    return APIResponse.success(data: resultData)
                }else{
                    return APIResponse.fail((code: .dataConverError, msg: "服务器异常，请稍后再试"))
                }
            }
            return APIResponse.fail((code: .unknownErrorCode ,msg: "未知错误"))
        }
        
        
    }
    
    func createRequest(url:String,
                       param:Dictionary<String,Any>? = nil,
                       method:HTTPMethod = .post,
                       timeout:TimeInterval = timeout) -> DataRequest {
        let formatedParam = param ?? [String:Any]()
        Logger.debug(" ============ http request ============"," url:\(url)"," method:\(method) "," param:",(formatedParam),"============ http request ============")
        let manager = SessionManager.default
        let dataRequest : DataRequest!
        do{
            var reqs = try URLRequest(url: url, method: method)
            reqs.timeoutInterval = timeout
            
            let encodedURLRequest = try URLEncoding.default.encode(reqs, with: formatedParam)
            dataRequest = manager.request(encodedURLRequest)
        }catch{
            dataRequest = manager.request(url, method: method, parameters: formatedParam)
        }
        return dataRequest
        
    }
}

enum HttpError: Error {
    case error(code: String?, msg: String)
    case unknowError
}

