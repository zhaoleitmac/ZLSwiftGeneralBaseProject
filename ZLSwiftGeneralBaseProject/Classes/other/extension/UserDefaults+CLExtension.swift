//
//  UserDefaults+CLExtension.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/9.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit


extension CLExtension where Base == UserDefaults {
    
    class func save(object: Any, forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(object, forKey: key)
        defaults.synchronize()
    }
    
    class func getObject(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
    
    func save(object: Any, forKey key: String) {
        self.base.set(object, forKey: key)
        self.base.synchronize()
    }
    
    func getObject(forKey key: String) -> Any? {
        return self.base.object(forKey: key)
    }
    
    func showOrderRemind(orderIds: [String]) -> Bool {
        let remindData: Data? = self.getObject(forKey: String.newOrderRemind) as? Data
        if remindData != nil {
            let reminds: Set<String> = NSKeyedUnarchiver.unarchiveObject(with: remindData!) as! Set
            for orderId in orderIds {
                if reminds.contains(orderId) {
                    return true
                }
            }
        }
        return false

    }
    
}
