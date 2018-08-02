//
//  TaskStatus.swift
//  ZHDJ
//
//  Created by liuchang on 2017/4/13.
//  Copyright © 2017年 com.akira. All rights reserved.
//

import Foundation

enum TaskStatus {
    case executing
    case executingText(desc: String)
    case success
    case empty(desc: String, imageName: String?)
    case fail(error: String)
    case notNetwork
    case loginDateOut
    
    static let unknownError:TaskStatus = .fail(error: "未知错误，请稍候再试")

    static let defaultEmpty:TaskStatus = .empty(desc: "暂无数据", imageName: "no_data_img")
    
    var isExecuting: Bool {
        switch self {
        case .executing:
            return true
        default:
            return false
        }
    }
    var isFail: Bool {
        switch self {
        case .fail(_):
            return true
        default:
            return false
        }
    }
    var failMsg: String? {
        switch self {
        case .fail(let msg):
            return msg
        default:
            return nil
        }
    }
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var isEmpty: Bool {
        switch self {
        case .empty:
            return true
        default:
            return false
        }
    }
    
    var isNoNetWork: Bool {
        switch self {
        case .notNetwork:
            return true
        default:
            return false
        }
    }
    
    var isLoginDateOut: Bool {
        switch self {
        case .loginDateOut:
            return true
        default:
            return false
        }
    }
    
    
}
