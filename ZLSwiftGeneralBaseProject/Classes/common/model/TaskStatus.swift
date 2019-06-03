//
//  TaskStatus.swift
//  ZHDJ
//
//  Created by liuchang on 2017/4/13.
//  Copyright © 2017年 com.akira. All rights reserved.
//

import Foundation

enum TaskStatus {
    
    case flashHUD(msg: String)
    case executing
    case executingText(desc: String)
    case success
    case successText(desc: String)
    case complete
    case noMore
    case empty(desc: String?, imageName: String?)
    case fail(error: String?)
    case failImage(error: String?, imageName: String?)
    case noNetwork
    
    static let unknownError:TaskStatus = .fail(error: "未知错误，请稍候再试")

    static let defaultEmpty:TaskStatus = .empty(desc: "暂无数据", imageName: "no_data_img")
    
    var isExecuting: Bool {
        switch self {
        case .executing, .executingText:
            return true
        default:
            return false
        }
    }
    
    var isFail: Bool {
        switch self {
        case .fail(_):
            return true
        case .failImage(_, _):
            return true
        default:
            return false
        }
    }
    
    var failMsg: String? {
        switch self {
        case .fail(let msg):
            return msg
        case .failImage(let msg, _):
            return msg
        default:
            return nil
        }
    }
    
    var isSuccess: Bool {
        switch self {
        case .success, .successText:
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
        case .noNetwork:
            return true
        default:
            return false
        }
    }
    
    var isFinished: Bool {
        switch self {
        case .flashHUD, .success, .successText, .complete, .noMore, .empty, .fail, .failImage, .noNetwork:
            return true
        default:
            return false
        }
    }
    
}
