//
//  Codable+ZLExtension.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/18.
//  Copyright © 2017年 ZhaoLei. All rights reserved.
//

import UIKit

extension Encodable {
    
    func jsonDictionary() -> [String : Any]? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonDic = try? JSONSerialization.jsonObject(with:jsonData,options: .mutableContainers) as? [String : Any]
            return jsonDic!
        } else {
            return nil
        }
    }
}

extension Decodable {
    
    static func instance(with dic: [String : Any]) -> Self? {
        let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        return self.instance(with: data)
    }
    
    static func instance(with data: Data?) -> Self? {
        if let data = data {
            do {
                let instance = try JSONDecoder().decode(self, from: data)
                return instance
            } catch {
                debugPrint(error)
                return nil
            }
        } else {
            return nil
        }
    }
    
}

extension ZLExtension where Base == String {
    
    class func jsonString(with jsonValue: Any) -> String? {
        var jsonData: Data? = nil
        if JSONSerialization.isValidJSONObject(jsonValue) {
            jsonData = try? JSONSerialization.data(withJSONObject: jsonValue, options: [])
        }
        if let jsonData = jsonData {
            return String(data: jsonData, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func jsonValue() -> Any? {
        let jsonData = self.base.data(using: .utf8)!
        let jsonValue = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return jsonValue
    }

}
