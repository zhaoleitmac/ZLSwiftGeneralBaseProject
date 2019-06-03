//
//  UserDefaults+ZLExtension.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/9.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit


extension ZLExtension where Base == UserDefaults {
    
    class func save(object: Any?, forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(object, forKey: key)
        defaults.synchronize()
    }
    
    class func getObject(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
    
    func save(object: Any?, forKey key: String) {
        self.base.set(object, forKey: key)
        self.base.synchronize()
    }
    
    func getObject(forKey key: String) -> Any? {
        return self.base.object(forKey: key)
    }
    
}
