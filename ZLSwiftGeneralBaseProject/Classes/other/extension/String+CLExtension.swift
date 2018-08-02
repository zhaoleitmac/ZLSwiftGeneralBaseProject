//
//  String+CLExtension.swift
//  ggcms
//
//  Created by liuchang on 2017/8/10.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import Foundation
import UIKit
extension CLExtension where Base == String {

    func sizeWithFont(size: CGSize? = nil, font: UIFont) -> CGSize {
        let textSize:CGSize
        if let size = size {
            textSize = self.base.boundingRect(with: CGSize(width: size.width, height: size.height), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font : font], context: nil).size
        }else {
            textSize = self.base.size(withAttributes:[NSAttributedStringKey.font : font])
        }
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }

    func changeHttpToHttps() -> String {
        if !self.base.hasPrefix("https") && self.base.hasPrefix("http") {
            #if (DEV_CD || DEV_BJ)
                return self.base.replacingOccurrences(of: "http", with: "https")
            #else
                return self.base
            #endif
        } else {
            return self.base
        }
    }
    
    func isMobilePhoneNumber() -> Bool {
        var isMobilePhoneNumber = true
        if self.base.cl.length < 11 {
            isMobilePhoneNumber = false
        } else {
            let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
            let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
            isMobilePhoneNumber = regexMobile.evaluate(with: self.base)
        }
        return isMobilePhoneNumber
    }
    
    class func toJSONString(object: Any) -> String {
        
        let data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        if let data = data {
            return String(data: data, encoding: String.Encoding.utf8)!
        } else {
            return ""
        }
    }
}
