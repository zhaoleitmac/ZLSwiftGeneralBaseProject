//
//  Dictionary+ZLExtension.swift
//  YFCB
//
//  Created by 赵雷 on 2018/12/23.
//  Copyright © 2018 缀新网络技术有限公司. All rights reserved.
//

import UIKit
import Alamofire

extension Dictionary: ZLExtensionCompatible{}

extension ZLExtension where Base == [String: Any] {
    
    func urlEncodingAppended(by host: String) -> String {
        guard self.base.count > 0 else {
            return host
        }
        var url = host
        if url.count > 0 {
            url.append("?")
        }
        let paramStr = self.urlEncoding()
        url.append(paramStr)
        return url
    }
    
    func urlEncoding() -> String {
        let parameters = self.base
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += URLEncoding.default.queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
}
