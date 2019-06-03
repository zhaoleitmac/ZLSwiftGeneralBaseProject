//
//  CGExtension.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/21.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

extension CGRect {
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
}

extension CGSize {
    init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
}

extension CGPoint {
    
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
    
    

    
}

extension ZLExtension where Base == CGPoint {
    // 距离
    func distance(to point: CGPoint) -> CGFloat {
        let x: CGFloat = self.base.x - point.x
        let y: CGFloat = self.base.y - point.y
        
        return sqrt(x * x + y * y)
    }
    
    // 角度
    func radius(to point: CGPoint) -> CGFloat {
        let x: CGFloat = self.base.x - point.x
        let y: CGFloat = self.base.y - point.y
        return atan2(x, y)
    }
}


extension ZLExtension where Base == CGFloat {
    
    func percentageValueText() -> String {
        let mutyString = String(format: "%.2f", self.base)
        let value = Float(mutyString) ?? 0.0
        if value == 0 || value == 0.00 || value <= 0.01 {
            return "0"
        } else if value == 1 {
            return "100%"
        } else {
            return mutyString + "\(value)\("%")"
        }
    }

}

extension CGPoint: ZLExtensionCompatible{}
extension CGFloat: ZLExtensionCompatible{}
