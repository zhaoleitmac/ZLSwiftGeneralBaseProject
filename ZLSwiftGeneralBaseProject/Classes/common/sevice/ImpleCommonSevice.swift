//
//  ImpleCommonSevice.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/23.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

class ImpleCommonSevice: NSObject, ICommonSevice, SingletonAvaliable {

    required override init() {
        super.init()
    }
    
    func checkAccountValidable(account: String) -> String? {
        return account.zl.isMobilePhoneNumber() ? nil : "请输入合法的手机号码"
    }
        func checkLoginInfo(account: String, code: String) -> String? {
        if account.zl.isMobilePhoneNumber() {
            return "请输入合法的手机号码"
        }
        if code.zl.length != 6 {
            return "验证码输入错误"
        }
        return nil
    }

    
}
