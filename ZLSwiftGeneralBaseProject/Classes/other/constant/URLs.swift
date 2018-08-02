//
//  URLs.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/8.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

enum URLs: String {
    
    enum Path: String {
        case dev = "https://dev.zlfw.com/";
        case release = "https://www.zlfw.com/"
        
        static var current: String{
            get{
                #if DEV
                    return Path.dev.rawValue
                #else
                    return Path.release.rawValue
                #endif
            }
        }

    }
    
    case getLoginCode = "generateCode.action" //老板登录验证码
    case login = "login.action" //登录

    var url: String  {
        get {
            return Path.current.cl.appendPathComponent(self.rawValue)
        }
    }
    
    var appNodeUrl: String {
        get {
            let url: String?
            #if DEV
            url = "https://dev.zlfw.com/"
            #else
            url = "https://www.zlfw.com/"
            #endif
            if let appNodeUrl = url {
                return appNodeUrl.cl.changeHttpToHttps().cl.appendPathComponent(self.rawValue)
            } else {
                return ""
            }
        }
    }
    
}
