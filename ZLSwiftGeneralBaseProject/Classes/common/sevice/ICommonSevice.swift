//
//  ICommonSevice.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/23.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

protocol ICommonSevice {
    //校验手机号
    func checkAccountValidable(account: String) -> String?
    //校验登录信息
    func checkLoginInfo(account: String, code: String) -> String?
    
}


extension ICommonSevice {
    
}
