//
//  APIError.swift
//  ZHDJ
//
//  Created by 刘昶 on 2017/4/12.
//  Copyright © 2017年 com.akira. All rights reserved.
//

import Foundation

enum APIError: Error {
    
    case remoteServiceError(code: Int, message: String)
    case netWorkError

    static func remoteServerError(code: Int? = nil, message: String? = nil) -> APIError {
        return .remoteServiceError(code: code ?? -1, message: message ?? "服务器异常，请稍后再试")
    }
}

extension APIError {
    var localizedDescription: String {
        switch self {
        case .netWorkError:
            return "网络异常，请检查网络设置"
        case .remoteServiceError( _, let message):
            return message
        }
    }
}
