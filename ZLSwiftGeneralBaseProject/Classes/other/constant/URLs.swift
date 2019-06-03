//
//  URLs.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/8.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

enum URLs: String {
    
    private enum Domin: String {
        case dev = "https://dev.zlfw.com/";
        case release = "https://www.zlfw.com/"
        
        static var current: String{
            get{
                #if DEV
                    return Domin.dev.rawValue
                #else
                    return Domin.release.rawValue
                #endif
            }
        }

    }
    
    case getLoginCode = "generateCode.action" //获取登录验证码
    case login = "login.action" //登录

    var url: String  {
        get {
            return Domin.current.zl.appendPathComponent(self.rawValue)
        }
    }
    
}
