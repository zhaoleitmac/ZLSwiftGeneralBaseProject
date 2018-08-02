//
//  ImpleAppNodeAPI.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/23.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxSwift

class ImpleAppNodeAPI: NSObject, IAppNodeAPI, HttpRequestAble, SingletonAvaliable {

    override required init() {
        super.init()
    }
    
    func getLoginCode(phoneNum: String) -> Observable<APIResponse<APIResult>> {
        let param = ["phone": phoneNum, "action": "1"]
        return self.postJson(url: ImpleAppNodeAPI.getLoginCode, param:param)
    }
    
}

extension ImpleAppNodeAPI {
    private static let login = URLs.login.url
    private static let getLoginCode = URLs.getLoginCode.url
    
    
}
