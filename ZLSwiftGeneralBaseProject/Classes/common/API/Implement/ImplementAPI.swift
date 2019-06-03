//
//  ImplementAPI.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/23.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxSwift

class ImplementAPI: NSObject, API, HttpRequestAble, SingletonAvaliable {

    override required init() {
        super.init()
    }
    
    func getLoginCode(info: LoginCodeReqInfo) -> Observable<APIResult<APIBaseResponse>> {
        return self.postJson(url: URLs.login.url, param: info.param())
    }
    
}

