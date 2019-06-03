//
//  API.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/23.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol API {
    
    //获取登录验证码
    func getLoginCode(info: LoginCodeReqInfo) -> Observable<APIResult<APIBaseResponse>>

}

