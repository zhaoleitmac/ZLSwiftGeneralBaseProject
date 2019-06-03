//
//  RequestInfo.swift
//  YFCB
//
//  Created by 赵雷 on 2018/10/19.
//  Copyright © 2018 缀新网络技术有限公司. All rights reserved.
//

import UIKit

protocol RequestInfo: Encodable {
    func param(isWithToken: Bool) -> [String : Any]
}

extension RequestInfo {
    
    func param(isWithToken: Bool = true) -> [String : Any] {
        var param = self.jsonDictionary() ?? [String : Any]()
        if isWithToken, let token = User.current.token {
            param["token"] = token
        }
        return param
    }
    
}
