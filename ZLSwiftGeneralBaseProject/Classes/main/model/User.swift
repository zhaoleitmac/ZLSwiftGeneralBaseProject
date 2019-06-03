//
//  User.swift
//  YFCB
//
//  Created by 赵雷 on 2018/10/19.
//  Copyright © 2018 缀新网络技术有限公司. All rights reserved.
//

import UIKit

class User: NSObject {
    
    @objc class var current: User {
        get {
            if User.currentUser == nil {
                User.currentUser = User()
            }
            return User.currentUser!
        }
    }
    
    private static var currentUser: User?
    
    private enum UserStoreKey: String {
        case account = "KEY_USER_ACCOUNT"
        case pwd = "KEY_USER_PWD"

        //接口授权
        case token = "KEY_ACCOUNT_ACCESS_TOKEN"

        
    }
    
    //用户id
    var account: String? {
        set {
            UserDefaults.zl.save(object: newValue, forKey: UserStoreKey.account.rawValue)
        }
        get {
            let value = UserDefaults.zl.getObject(forKey:UserStoreKey.account.rawValue)
            return value as? String
        }
    }
    
    var pwd: String? {
        set {
            UserDefaults.zl.save(object: newValue, forKey: UserStoreKey.pwd.rawValue)
        }
        get {
            let value = UserDefaults.zl.getObject(forKey:UserStoreKey.pwd.rawValue)
            return value as? String
        }
    }
    
    //用户中心的token
    @objc var token: String? {
        set {
            UserDefaults.zl.save(object: newValue, forKey: UserStoreKey.token.rawValue)
        }
        get {
            let value = UserDefaults.zl.getObject(forKey:UserStoreKey.token.rawValue)
            return value as? String
        }
    }
    
    func remove() {
        self.token = nil
    }
    
    class func remove() {
        self.current.remove()
    }

}

