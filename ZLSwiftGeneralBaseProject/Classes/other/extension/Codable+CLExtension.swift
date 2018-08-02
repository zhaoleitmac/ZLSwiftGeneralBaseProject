//
//  Codable+CLExtension.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/18.
//  Copyright © 2017年 ZhaoLei. All rights reserved.
//

import UIKit

extension CLExtension where Base: Encodable {
    
    func jsonDictionary() -> [String : Any]? {
        if let jsonData = try? JSONEncoder().encode(self.base) {
            let jsonDic = try? JSONSerialization.jsonObject(with:jsonData,options: .mutableContainers) as? [String : Any]
            return jsonDic!
        } else {
            return nil
        }
    }
}

extension CLExtension where Base: Decodable {
    
    class func instance(with dic: [String : Any]) -> Base? {
        let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        if let data = data {
            return try? JSONDecoder().decode(Base.self, from: data)
        } else {
            return nil
        }
        
    }
    
}

