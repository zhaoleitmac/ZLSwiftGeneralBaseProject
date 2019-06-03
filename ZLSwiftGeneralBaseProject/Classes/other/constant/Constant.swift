//
//  Constant.swiftreduceBtn
//  GGSJ
//
//  Created by 赵雷 on 2017/9/11.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

///屏幕bounds
let kScreenBounds = UIScreen.main.bounds
/// 屏宽
let kScreenWidth = kScreenBounds.width
/// 屏高
let kScreenHeight = kScreenBounds.height


extension UIColor {
    
    static let tableViewBackground = UIColor.zl.garyWithSameValue(245)
    
    static let appMain = UIColor.zl.fromHex("108EE9")
    
    static let whiteBtnHighlighted = UIColor.zl.garyWithSameValue(229)
    
    // MARK: - navi color
    static let naviBarBG = UIColor.zl.fromRGBA(28, 28, 32)
    static let shadowBG = UIColor.zl.fromRGBA(220, 220, 220)
    static let naviBarTitle = UIColor.zl.fromRGBA(255, 255, 255)
    static let naviBarItemsTint =  UIColor.zl.fromRGBA(255, 255, 255)
    static let naviBarItems = UIColor.zl.fromRGBA(255, 255, 255)
}


extension UIFont {
    // MARK:- navi font
    static let naviBarTitleFont = UIFont.systemFont(ofSize: 17)
    static let naviBarItemFont = UIFont.systemFont(ofSize: 15)

}

// MARK:- Notification Name

enum NotificationName: NSNotification.Name {
    //登录相关
    case userSignIn = "sign_in_notification" //账户登入
    case userSignOut = "sign_out_notification" // 账户登出
}

extension Notification.Name: ExpressibleByStringLiteral{
    public init(stringLiteral value: String) {
        self.init(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    
}

extension String {
    static let kJSESSIONID = "JSESSIONID"

    
    static let newOrderRemind = "new_order_remind"
    static let loadedQRURLKey = "qr_url"
    static let httpSuccessCode = "00"
    static let httpNetWorkNotWorkCode = "-501"
    static let activityStatus = "activity_status"
}

extension TimeInterval {
    
    static let animationInterval = 0.25
    
}
