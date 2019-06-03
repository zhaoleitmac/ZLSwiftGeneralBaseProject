//
//  UIDevice+ZLExtension.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/11.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

extension ZLExtension where Base: UIDevice {
    
    func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,3":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPhone9,4":                               return "iPhone 7 Plus"
        case "iPhone10,1":                              return "iPhone 8"
        case "iPhone10,4":                              return "iPhone 9"
        case "iPhone10,2":                              return "iPhone 8 Plus"
        case "iPhone10,5":                              return "iPhone 8 Plus"
        case "iPhone10,3":                              return "iPhone X"
        case "iPhone10,6":                              return "iPhone X"
           
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"

        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    func is4or4s() -> Bool {
        return self.deviceModel().hasPrefix("iPhone 4")
    }
    func is5or5sor5corSE() -> Bool {
        return self.deviceModel().hasPrefix("iPhone 5") || self.deviceModel().hasPrefix("iPhone SE")
    }
    func hasBang() -> Bool {
        return self.deviceModel().hasPrefix("iPhone X")
    }
    func formatedIdentifierForVendor() -> String? {
        let idfv = self.base.identifierForVendor?.uuidString
        return idfv?.replacingOccurrences(of: "-", with: "")
    }
    
    class func uuidString() -> String? {
        return Base.current.identifierForVendor?.uuidString
    }
    
    func topMargin(hasNavBar: Bool = true, vc: UIViewController? = nil) -> CGFloat {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        guard hasNavBar else {
            return statusHeight
        }
        var navHeight: CGFloat = 0
        if let vc = vc, let height = vc.navigationController?.navigationBar.frame.height {
            navHeight = height
        } else {
            navHeight = 44
        }
        return statusHeight + navHeight
    }
    
    func bottomMargin() -> CGFloat {
        return self.hasBang() ? 34 : 0
    }
    
}
