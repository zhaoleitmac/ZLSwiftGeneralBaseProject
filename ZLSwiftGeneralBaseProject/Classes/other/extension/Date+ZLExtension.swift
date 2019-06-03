//
//  Date+ZLExtension.swift
//  YFCB
//
//  Created by 赵雷 on 2018/11/9.
//  Copyright © 2018 缀新网络技术有限公司. All rights reserved.
//

import Foundation

extension ZLExtension where Base == Date {
    
    class func stringOfCurrentDate(dateFormat: String = "yyyyMMddHHmmssSSS") -> String {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat
        return formater.string(from: NSDate() as Date)
    }
    
    func isThisYear() -> Bool {
        let calendar = Calendar.current
        var nowCmps: DateComponents = calendar.dateComponents([.year], from: Date(timeIntervalSinceNow: 0))
        var thisCmps: DateComponents =  calendar.dateComponents([.year], from: self.base)
        return nowCmps.year == thisCmps.year
    }
    
    func isThisDay() -> Bool {
        let calendar = Calendar.current
        var nowCmps: DateComponents = calendar.dateComponents([.day, .month, .year], from: Date(timeIntervalSinceNow: 0))
        var thisCmps: DateComponents =  calendar.dateComponents([.day, .month, .year], from: self.base)
        return nowCmps.year == thisCmps.year && nowCmps.month == thisCmps.month && nowCmps.day == thisCmps.day
    }
    
    func duringRecently(in timeInterval: TimeInterval) -> Bool {
        return self.base + timeInterval > Date(timeIntervalSinceNow: 0)
    }
    
    func formateStr() -> String {
        if self.isThisYear() {
            if self.isThisDay() {
                if self.duringRecently(in: 3 * 60 * 60) {//3小时之内
                    let timeInterval = Date(timeIntervalSinceNow: 0).timeIntervalSince(self.base)
                    if self.duringRecently(in: 1 * 60 * 60) {//1小时之内
                        if self.duringRecently(in: 5 * 60) {//5分钟之内
                            return "刚刚"
                        } else {
                            return self.formateHourMiniteStr(timeInterval: timeInterval)
                        }
                    } else {
                        return self.formateHourMiniteStr(timeInterval: timeInterval)
                    }
                } else {
                    return "今天"
                }
            } else {
                return DateFormatter.zl.formatter(format: "MM-dd HH:mm").string(from: self.base)
            }
        } else {
            return DateFormatter.zl.formatter(format: "yyyy-MM-dd").string(from: self.base)
        }
    }
    
    private func formateHourMiniteStr(timeInterval: TimeInterval) -> String {
        let minites = Int(timeInterval / 60)
        let hour = minites / 60
        let remain = minites % 60
        if hour > 0 {
            return "\(hour)" + "小时" + "\(remain)" + "分前"
        } else {
            return "\(remain)" + "分之前"
        }
    }
}

extension ZLExtension where Base: NSDate {
    
    class func stringOfCurrentDate(dateFormat: String = "yyyyMMddHHmmssSSS") -> String {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat
        return formater.string(from: NSDate() as Date)
    }
}


//MARK:- DateFormatter
extension ZLExtension where Base: DateFormatter{
    
    class func formatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
}

extension Date: ZLExtensionCompatible{}
