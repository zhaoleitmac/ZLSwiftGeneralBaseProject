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
    
    static let appBlue = UIColor.cl.fromRGBA(22, 94, 181)
    static let mainColor1 = appBlue //APP_MAIN_1_COLOR
    static let mainColor2 = UIColor.cl.fromRGBA(0, 201, 255)    //APP_MAIN_2_COLOR
    static let mainColor2_translucent = UIColor.cl.fromRGBA(22, 94, 181, 0.5)   //APP_MAIN_2_COLOR_HALF_ALPHA
    static let mainColor3 = UIColor.cl.fromRGBA(0, 0, 0)    //APP_MAIN_3_COLOR
    static let mainColor3_translucent = UIColor.cl.fromRGBA(0, 0, 0, 0.5)    //APP_MAIN_3_COLOR_HALF_ALPHA
    static let appRed = UIColor.cl.fromRGBA(217,54,69)    //APP_RED_COLOR
    static let appRedMain = UIColor.cl.fromRGBA(207, 17, 45)    //APP_RED_COLOR_MAIN
    static let appRedAmount = UIColor.cl.fromRGBA(194, 0, 34)
    static let appBtnGreen = UIColor.cl.fromRGBA(60, 177, 108)
    
    // MARK: - navi color
    static let naviBarBG = UIColor.mainColor1
    static let naviBarTitle = UIColor.white
    static let naviBarItems = UIColor.white
    
    // MARK:- FontColor
    static let fontBlack1 = UIColor.cl.fromRGBA(0, 0, 0, 0.95)
    static let fontBlack2 = UIColor.cl.fromRGBA(0, 0, 0, 0.8)
    static let fontBlack3 = UIColor.cl.fromRGBA(0, 0, 0, 0.56)
    static let fontBlack4 = UIColor.cl.fromRGBA(0, 0, 0, 0.86)
    
    static let fontSendCoupon = UIColor.cl.garyWithSameValue(88)
    static let fontSendCouponYellow = UIColor.cl.fromRGBA(255, 175, 38)
    static let fontSendCouponGreen = UIColor.cl.fromRGBA(41, 166, 31)
    static let fontSendCouponPurple = UIColor.cl.fromRGBA(217, 52, 69)
    static let fontSendCouponPrize = UIColor.cl.fromRGBA(53, 130, 217)
    static let fontSendCouponNone = UIColor.cl.fromRGBA(19, 158, 143)

    // MARK:- lineColor
    static let navigationLine = UIColor.cl.fromRGBA(176, 176, 176)
    static let innerSeparator = UIColor.cl.fromRGBA(214, 214, 214, 0.6)
    static let outSeparator1 = UIColor.cl.fromRGBA(216, 216, 216)
    static let outSeparator2 = UIColor.cl.fromRGBA(230, 230, 230)
    
    // MARK:- otherColor
    static let couponRecordCell = UIColor.cl.fromRGBA(146, 146, 146)
    static let keyboardSeparator = UIColor.cl.fromRGBA(179, 179, 179)
    static let couponSendLine = UIColor.cl.fromRGBA(244, 244, 244)
    static let headerBtnBlue = UIColor.cl.fromRGBA(18, 105, 211)
    static let tableViewBackground = UIColor.cl.garyWithSameValue(245)

}


extension UIFont {
    // MARK:- navi font
    static let naviBarTitleFont = UIFont.systemFont(ofSize: 17)
    static let naviBarItemFont = UIFont.systemFont(ofSize: 15)

}

// MARK:- Notification Name

enum NotificationName: NSNotification.Name {
    //登录相关
    case userSignIn = "signIn_notification" //商家账户登入
    case employeeAuthed = "employee_authed" //员工授权成功
    case userSignOut = "signout_notification" // 账户登出

    
    case returnCouponUpdated = "return_coupon_updated" // 返券记录更新
    case newOrderRemind = "new_order_remind"    //新订单提醒
    case loadedQRURL = "load_qr_url_notification" //获取二维码
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
