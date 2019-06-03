//
//  UIColor+ZLExtension.swift
//  educationtools
//
//  Created by 赵雷 on 2019/4/23.
//  Copyright © 2019 北京红云融通技术有限公司. All rights reserved.
//

import UIKit

//MARK:- UIColor
extension ZLExtension where Base: UIColor{
    func getRGBA()->(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red,green,blue,alpha)
    }
    
    class func fromHex(_ hex: String, alpha: CGFloat = 1) -> UIColor {
        if let (red, green, blue) = hex.zl.RGB {
            return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
        }else {
            return UIColor.clear
        }
    }
    
    class func fromRGBA(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    class func garyWithSameValue(_ value: CGFloat) -> UIColor {
        return self.fromRGBA(value, value, value)
    }
}
