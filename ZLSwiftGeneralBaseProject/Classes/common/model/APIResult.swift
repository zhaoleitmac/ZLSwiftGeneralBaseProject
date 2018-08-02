//
//  APIResult.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/6.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import Foundation

class APIResult: NSObject, Codable {
    
    enum APIResultStatusCode: String, Codable {
        case success = "00"
        case errorParam = "01"
        case notNet = "-501"
        case exception = "-1"
        case unknown = "-999"
        case dateOut = "111"
    }
    
    var returnCode: String? {
        didSet {
            if let code = returnCode {
                let statusCode = APIResultStatusCode(rawValue: code) ?? .unknown
                self.statusCode = statusCode
            }
        }
    }
    var returnMsg: String?

    var statusCode: APIResultStatusCode = .unknown
    
    init(returnCode: String, returnMsg: String) {
        self.returnCode = returnCode;
        self.returnMsg = returnMsg;
    }
    
    convenience init(errorMsg: String) {
        self.init(returnCode: APIResultStatusCode.exception.rawValue, returnMsg: errorMsg)
    }
}
