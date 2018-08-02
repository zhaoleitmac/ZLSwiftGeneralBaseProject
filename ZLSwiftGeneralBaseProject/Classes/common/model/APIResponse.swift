//
//  APIResponse.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/11.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import Foundation

enum APIResponse<T: APIResult>{
    
    enum ResponseInnerError:String {
        case internetError = "102"
        case unknownErrorCode = "999"
        case dataConverError = "100"
        case noNetworfkError = "-501"
    }
    case success(data: T)
    case fail((code: ResponseInnerError, msg: String))
    
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
    
    var isloginDateOut: Bool {
        get{
            switch self {
            case .success(let data):
                return data.statusCode == .dateOut
            default:
                return false
            }
        }
    }
    
    var isRightData: Bool {
        get{
            switch self {
            case .success(let data):
                return data.statusCode == .success
            default:
                return false
            }
            
        }
    }
    
    var isNoNetWork: Bool {
        get{
            switch self {
            case let .fail(code, _):
                return code == .noNetworfkError
            default:
                return false
            }
            
        }
    }
}
