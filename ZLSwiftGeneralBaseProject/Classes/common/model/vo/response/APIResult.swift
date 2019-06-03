//
//  APIResult.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/11.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import Foundation

enum APIResult<T: APIBaseResponse> {
    
    case success(data: T)
    case fail(error: APIError)
    
    var data: T? {
        get {
            switch self {
            case .success(let data):
                return data
            default:
                return nil
            }
        }
    }
    
    var error: APIError? {
        get {
            switch self {
            case .fail(let error):
                return error
            case .success(let data):
                if !self.isCorrect {
                    return APIError.remoteServerError(code: data.code, message: data.msg)
                }
                return nil
            }
        }
    }
    
    var errorMSg: String? {
        return self.error?.localizedDescription
    }
    
    var isSuccess: Bool{
        get{
            switch self {
            case .success(_):
                return true
            default:
                return false
            }
        }
    }
    
    var isCorrect: Bool {
        get{
            switch self {
            case .success(let data):
                return data.isSuccess()
            default:
                return false
            }
            
        }
    }
    
    //token过期
    var isInvalid: Bool{
        get{
            switch self {
            case .success(let data):
                return data.isInvalid()
            default:
                return false
            }
        }
    }
    
    //用户不存在
    var isUserNoExist: Bool{
        get{
            switch self {
            case .success(let data):
                return data.isUserNoExist()
            default:
                return false
            }
        }
    }
    
    var isNoNetWork: Bool {
        get{
            switch self {
            case .fail(APIError.netWorkError):
                return true
            default:
                return false
            }
            
        }
    }
}
