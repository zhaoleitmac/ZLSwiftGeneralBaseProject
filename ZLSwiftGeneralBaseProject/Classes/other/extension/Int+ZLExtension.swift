//
//  Int+ZLExtension.swift
//  educationtools
//
//  Created by 赵雷 on 2019/4/23.
//  Copyright © 2019 北京红云融通技术有限公司. All rights reserved.
//

import Foundation

extension Int: ZLExtensionCompatible {}

//MARK:- Int
extension ZLExtension where Base == Int {
    
    func optionString() -> String {
        return "\(self.base)"
    }
    
    // int型时间格式化 X/XX ==>返回@"0X"/@"XX"
    func timeUnitFormat() -> String {
        var retStr: String
        if self.base >= 0 && self.base < 10 {
            retStr = String(format: "0%ld", self.base)
        } else {
            retStr = String(format: "%ld", self.base)
        }
        return retStr
    }
    
    func byteSizeStr() -> String {
        let byteSize = self.base
        if byteSize <= 0 {
            return "0B"
        } else if byteSize < 1024 { // < 1K
            return String(format: "%.ldB", byteSize)
        } else if byteSize < 1024 * 1024 { // < 1M
            let kiloByteSize = Float(byteSize) / 1024
            return String(format: "%.1fK", kiloByteSize)
        }  else if byteSize < 1024 * 1024 * 1024 {
            let millionByteSize = Float(byteSize) / (1024 * 1024)
            return String(format: "%.1fM", millionByteSize)
        } else {
            let gigaByteSize = Float(byteSize) / (1024 * 1024 * 1024)
            return String(format: "%.1fG", gigaByteSize)
        }
    }
    
    class func timestamp() -> Int? {
        let time = NSDate.zl.stringOfCurrentDate()
        return Int(time)
    }
}
