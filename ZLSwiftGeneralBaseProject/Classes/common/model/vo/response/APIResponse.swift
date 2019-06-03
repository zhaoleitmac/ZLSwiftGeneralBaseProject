//
//  APIResponse.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/6.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import Foundation

enum APIBaseResponseKey: String, CodingKey {
    case code
    case msg
    case data
}

class APIBaseResponse: Decodable {
    
    enum APIResultStatus: Int, Codable {
        
        case success = 1
        case invalid = -99
        case wrongParam = 10
        case userNoExist = 20
        case unknown = -999 //未知错误

    }
    
    var code: Int
    
    var msg: String
    
    func isSuccess() -> Bool {
        return code == APIResultStatus.success.rawValue
    }
    
    func isInvalid() -> Bool {
        return code == APIResultStatus.invalid.rawValue
    }
    
    func isUserNoExist() -> Bool {
        return code == APIResultStatus.userNoExist.rawValue && msg == "登录用户不存在"
    }
    
    init(code: Int, msg: String) {
        self.code = code
        self.msg = msg
    }
    
    convenience init(errorMsg: String) {
        self.init(code: APIResultStatus.unknown.rawValue, msg: errorMsg)
    }
    
    func status() -> APIResultStatus {
        return APIResultStatus(rawValue: self.code) ?? .unknown
    }

}

class APIResponse<T: Decodable>: APIBaseResponse {
    
    var data: T?
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: APIBaseResponseKey.self)
        var data: T?
        do {
            data = try container.decode(T.self, forKey: .data)
        } catch let error {
            Logger.debug(error)
            data = nil
        }
        let code = try container.decode(Int.self, forKey: .code)
        let msg = try container.decode(String.self, forKey: .msg)

        try super.init(from: decoder)
        self.code = code
        self.msg = msg
        self.data = data
    }
    
}


