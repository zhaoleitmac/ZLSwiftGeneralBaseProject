//
//  String+ZLExtension.swift
//  ggcms
//
//  Created by liuchang on 2017/8/10.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

private let DES_SYMMETRIC_KEY: String = "0a78726e4c12b30a13c601bc334419ab"

extension String: ZLExtensionCompatible {}

extension ZLExtension where Base == String {

    var md5: String {
        
        let cStrl = self.base.cString(using: String.Encoding.utf8)
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer)
        var md5String = ""
        for i in 0 ..< length {
            let obcStrl = String.init(format: "%02x", buffer[i])
            md5String.append(obcStrl)
        }
        free(buffer)
        return md5String
        
    }
    
    var RGB : (red:CGFloat,green:CGFloat,blue:CGFloat)? {
        var cString = base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        // String should be 6 or 8 characters
        if (cString.zl.length < 6) {
            return nil
        }
        
        // strip 0X if it appears
        if (cString.hasPrefix("0X")){
            cString = cString.zl.substring(from: 2)
        }
        if (cString.hasPrefix("#")){
            cString = cString.zl.substring(from: 1)
        }
        if cString.count != 6 {
            return nil
        }
        // Separate into r, g, b substrings
        //r
        let rString = cString.zl.substring(start: 0, end: 2)
        
        //g
        
        let gString = cString.zl.substring(start: 2, end: 4)
        
        //b
        let bString = cString.zl.substring(start: 4, end: 6)
        
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return (CGFloat(r),CGFloat(g),CGFloat(b))
    }
    var color: UIColor {
        return UIColor.zl.fromHex(base)
    }
    
    public var length :Int {
        get{return (self.base).count}
    }
    
    func appendPathComponent(_ str:String) -> String {
        let newString = (self.base as NSString).appendingPathComponent(str)
        return newString
    }
    
    func charAt(_ index:Int) ->Character?{
        let str = self.base
        if (index > str.count
            || index < 0){
            return nil
        }else{
            return str[str.index(str.startIndex, offsetBy: index)]
        }
    }
    
    private func parse(_ char:Character) -> UInt32{
        
        let charUnicode = UnicodeScalar(String(char))!.value
        let aUnicode = UnicodeScalar("a")!.value
        let AUnicode = UnicodeScalar("A")!.value
        
        if (charUnicode >= aUnicode){
            return UInt32(charUnicode - aUnicode + 10) & 0x0f
        }else if(charUnicode >= AUnicode){
            return UInt32(charUnicode - AUnicode + 10) & 0x0f
        }else{
            return UInt32(charUnicode - UnicodeScalar("0")!.value) & 0x0f
        }
        
    }
    private func hexString2Data() -> Data {
        let str = self.base
        var data = Data(count: str.count / 2)
        
        var charIndex = 0
        (0 ..< data.count).forEach { (index) in
            let c1 = self.charAt(charIndex)
            charIndex += 1
            let c2 = self.charAt(charIndex)
            charIndex += 1
            let byte = (self.parse(c1!) << 4) | parse(c2!)
            data[index] = UInt8(byte)
        }
        
        return data
    }
    
    func trim(_ charset:CharacterSet = CharacterSet.whitespacesAndNewlines) -> Base {
        return self.base.trimmingCharacters(in: charset)
    }
    
    func isEmpty(needTrim:Bool = true) -> Bool {
        if needTrim {
            return self.trim().count == 0
        }else{
            return self.base.count == 0
        }
    }
    
    func image() -> UIImage? {
        return UIImage(named: self.base)
    }
    
    func sizeWithFont(size: CGSize? = nil, font: UIFont) -> CGSize {
        let textSize:CGSize
        if let size = size {
            textSize = self.base.boundingRect(with: CGSize(width: size.width, height: size.height), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil).size
        }else {
            textSize = self.base.size(withAttributes:[NSAttributedString.Key.font : font])
        }
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }

    func changeHttpToHttps() -> String {
        if !self.base.hasPrefix("https") && self.base.hasPrefix("http") {
            #if (DEV)
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
        if self.base.zl.length < 11 {
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
    
    //string是since1970时format为nil
    func transformFormat(sourceFormat: String? = nil, targetFormat: String = "yyyy-MM-dd HH:mm") -> String? {
        var date: Date? = nil
        if let sourceFormat = sourceFormat {
            let formatter = DateFormatter.zl.formatter(format: sourceFormat)
            date = formatter.date(from: self.base)
        } else {
            date = Date.init(timeIntervalSince1970: (Double(self.base) ?? 0))
        }
        if let date = date {
            let targetFormatter = DateFormatter.zl.formatter(format: targetFormat)
            return targetFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    ///真实长度
    var actualLength: Int {
        get {
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            var da: Data? = self.base.data(using: String.Encoding(rawValue: enc))
            return da?.count ?? 0

        }
    }
    
    ///根据秒数获取总时间字符串（99:59:59）
    
    class func getTimeStr(seconds: Int) -> String {
        var timeStr = "00:00:00"
        var hour: Int = 0
        var minute: Int = 0
        var second: Int = 0
        if seconds > 0 {
            minute = seconds / 60
            hour = minute / 60
            if hour > 99 {
                // 最大值
                timeStr = "99:59:59"
            } else {
                minute = minute % 60
                second = seconds - hour * 3600 - minute * 60
                timeStr = hour.zl.timeUnitFormat() + ":" + minute.zl.timeUnitFormat() + ":" + second.zl.timeUnitFormat()
            }
        }
        return timeStr
    }
    
    class func getTimeStr(duration: TimeInterval, includeHour: Bool = true) -> String {
        
        if includeHour {
            let hoursElapsed = floor(duration / 3600.0)
            let minutesElapsed = floor(fmod(duration, 3600.0) / 60.0)
            let secondsElapsed = fmod(duration, 60.0)
            return String(format: "%02.0f:%02.0f:%02.0f", hoursElapsed, minutesElapsed, secondsElapsed)
        } else {
            let minutesElapsed = floor(duration / 60.0)
            let secondsElapsed = fmod(duration, 60.0)
            return String(format: "%02.0f:%02.0f", minutesElapsed, secondsElapsed)
        }

    }
    
    func appendString(string: String, prefix: String) -> String {
        var oString = self.base
        if string.count > 0 {
            if oString.count > 0 {
                oString.append(prefix)
                oString.append(string)
            } else {
                oString.append(string)
            }
        }
        return oString
    }
    
    func removeTransferredMeaning() -> String  {
        var string = self.base
        var character: String? = nil
        for i in 0..<string.count {
            character = (string as NSString).substring(with: NSRange(location: i, length: 1))
            if (character == "\\") {
                if let subRange = Range<String.Index>(NSRange(location: i, length: 1), in: string) {
                    string.removeSubrange(subRange)
                }
            }
        }
        return string
    }
    
    func isValidIP() -> Bool {
        let ipStr = self.base
        let ipArray = ipStr.components(separatedBy: ".")
        if ipArray.count == 4 {
            for ipnumberStr: String in ipArray {
                let ipnumber = Int(ipnumberStr) ?? -1
                if !(ipnumber >= 0 && ipnumber <= 255) {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func index(of substring : String) -> Int {
        let range = self.base.range(of: substring)
        return range?.lowerBound.encodedOffset ?? 0
    }
    
    func lastIndex(of substring : String) -> Int {
        let range = self.base.range(of: substring, options: .backwards)
        return range?.lowerBound.encodedOffset ?? 0
    }
    
    func substring(to: Int) -> String {
        let endIndex = String.Index.init(encodedOffset: to)
        let subStr = self.base[self.base.startIndex..<endIndex]
        return String(subStr)
    }
    
    func substring(from: Int) -> String {
        let startIndex = String.Index.init(encodedOffset: from)
        let subStr = self.base[startIndex..<self.base.endIndex]
        return String(subStr)
    }
    
    func substring(start: Int, end: Int) -> String {
        let startIndex = String.Index.init(encodedOffset: start)
        let endIndex = String.Index.init(encodedOffset: end)
        return String(self.base[startIndex..<endIndex])
    }
    
    func pinYinStr() -> String {
        var mutableString = self.base
        let cfString: CFMutableString = mutableString as! CFMutableString
        CFStringTransform(cfString, nil, kCFStringTransformToLatin, false)
        mutableString = mutableString.folding(options: .diacriticInsensitive, locale: NSLocale.current)
        return mutableString

    }
    
    func pinYinHeadStr() -> String {
        let full = self.pinYinStr().capitalized
        var str = ""
        let rex = try? NSRegularExpression(pattern: "[A-Z]", options: [])
        let results = rex?.matches(in: full, options: [], range: NSRange(location: 0, length: full.count))
        for result in results ?? [] {
            str += (full as NSString).substring(with: result.range)
        }
        return str

        
    }
    
    var isNumber: Bool {
        let temp = "^[0-9]+\\.?[0-9]{0,2}$"
        let filter = NSPredicate(format: "SELF MATCHES %@", temp)
        return filter.evaluate(with: self.base)
    }
    
}

