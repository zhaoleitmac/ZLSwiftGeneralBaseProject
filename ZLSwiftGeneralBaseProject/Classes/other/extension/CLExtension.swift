//
//  UIDevice+CLExtension.swift
//  citizen
//
//  Created by liuchang on 2016/11/10.
//  Copyright © 2016年 com.qmlw. All rights reserved.
//

import UIKit

public class CLExtension<Base> {
    public let base : Base
    public init(_ base:Base) {
        self.base = base
    }

}
public protocol CLExtensionCompatible {
    associatedtype CLExtenstionCompatibleType
    static var cl:CLExtension<CLExtenstionCompatibleType>.Type{get set}
    var cl:CLExtension<CLExtenstionCompatibleType>{get set}
}
extension CLExtensionCompatible{
    public static var cl:CLExtension<Self>.Type{
        get{
            return CLExtension<Self>.self
        }
        set{

        }
    }
    public var cl:CLExtension<Self>{
        get{
            return CLExtension(self)
        }
        set{

        }
    }
}

//MARK:- View frames about
extension CLExtension where Base:UIView{
    public var width:CGFloat{
        get{
            return self.base.bounds.size.width
        }
        set{
            self.base.frame.size.width = newValue
        }
    }
    public var height:CGFloat{
        get{
            return self.base.frame.size.height
        }
        set{
            self.base.frame.size.height = newValue
        }
    }

    public var x:CGFloat{
        get{
            return self.base.frame.origin.x
        }
        set{
            self.base.frame.origin.x = newValue
        }
    }
    public var y:CGFloat{
        get{
            return self.base.frame.origin.y
        }
        set{
            self.base.frame.origin.y = newValue
        }
    }
}

//MARK: - String
private let DES_SYMMETRIC_KEY:String = "0a78726e4c12b30a13c601bc334419ab"
extension CLExtension where Base == String{


//    var md5: String {
//        let str = self.base
//        let cStr = str.cString(using: String.Encoding.utf8);
//        let length = Int(CC_MD5_DIGEST_LENGTH)
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
//        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
//        let md5String = NSMutableString();
//        for i in 0 ..< length{
//            md5String.appendFormat("%02x", buffer[i])
//        }
//        free(buffer)
//        return md5String as String
//        
//    }
    var RGB : (red:CGFloat,green:CGFloat,blue:CGFloat)? {
        var cString = base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        // String should be 6 or 8 characters
        if (cString.cl.length < 6) {
            return nil
        }

        // strip 0X if it appears
        if (cString.hasPrefix("0X")){
            cString = cString.cl.substring(2)
        }
        if (cString.hasPrefix("#")){
            cString = cString.cl.substring(1)
        }
        if cString.characters.count != 6{
            return nil
        }
        // Separate into r, g, b substrings
        //r
        let rString = cString.cl.substring(0, 2)

        //g

        let gString = cString.cl.substring(2, 4)

        //b
        let bString = cString.cl.substring(4, 6)

        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)

        return (CGFloat(r),CGFloat(g),CGFloat(b))
    }
    var color:UIColor{
        return UIColor.cl.fromHex(base)
    }

    public var length :Int{
        get{return (self.base).count}
    }

    func appendPathComponent(_ str:String) -> String {
        let newString = (self.base as NSString).appendingPathComponent(str)
        return newString
    }

    func charAt(_ index:Int) ->Character?{
        let str = self.base 
        if (index > str.characters.count
            || index < 0){
            return nil
        }else{
            return str[str.characters.index(str.characters.startIndex, offsetBy: index)]
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
        var data = Data(count: str.characters.count / 2)

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

//    func crypt(operation:CCOperation,
//               algorithm:CCAlgorithm,
//               option:CCOptions,
//               keyData:Data,
//               keyLength:Int,
//               stringData:Data) ->Data?{
//        let keyBytes = keyData.withUnsafeBytes{(bytes:UnsafePointer<UInt8>) in
//            return bytes
//        }
//        let dataBytes = stringData.withUnsafeBytes{ (bytes:UnsafePointer<UInt8>) in
//            return bytes
//        }
//        let padding = stringData.count % 8
//        let dataLength = stringData.count + (padding == 0 ? 0 : 8 - padding)
//        let ivData = Data(count: 8).withUnsafeBytes{ (bytes:UnsafePointer<UInt8>) in
//            return bytes
//        }
//        var bufferData = Data(count: dataLength + 8)
//        let bufferLength = size_t(bufferData.count)
//        let bufferPointer = bufferData.withUnsafeMutableBytes{ (bytes:UnsafeMutablePointer<UInt8>) in
//            return bytes
//        }
//        var bytesDecrypted = Int(0)
//
//        let cryptStatus = CCCrypt(operation, algorithm, option, keyBytes, keyLength, ivData, dataBytes, dataLength, bufferPointer, bufferLength, &bytesDecrypted)
//
//        if Int32(kCCSuccess) == cryptStatus{
//            bufferData.count = bytesDecrypted
//            return bufferData
//        }else{
//            print("cryptError code : \(cryptStatus)")
//            return nil
//        }
//
//    }
//
//    func encryptUseDes(_ key:String = DES_SYMMETRIC_KEY) -> Base? {
//        let operation = CCOperation(kCCEncrypt)
//        let algorithm = CCAlgorithm(kCCAlgorithmDES)
//        let option = CCOptions(kCCOptionECBMode)
//
//        let str = self.base 
//        let keyData = key.cl.hexString2Data()
//
//        let keyLength = size_t(CCAlgorithm(kCCKeySizeDES))
//        let stringData : Data! = str.data(using: .utf8, allowLossyConversion: false)
//
//        let result = self.crypt(operation: operation, algorithm: algorithm, option: option, keyData: keyData, keyLength: keyLength, stringData: stringData)
//        return result?.base64EncodedString()
//
//    }
//
//
//    func decryptUseDes(_ key:String = DES_SYMMETRIC_KEY) -> Base? {
//        let operation = CCOperation(kCCDecrypt)
//        let algorithm = CCAlgorithm(kCCAlgorithmDES)
//        let option = CCOptions(kCCOptionECBMode)
//
//        let str = self.base 
//        let keyData = key.cl.hexString2Data()
//
//        let keyLength = size_t(CCAlgorithm(kCCKeySizeDES))
//        let stringData : Data! = Data(base64Encoded: str)
//        if let result = self.crypt(operation: operation, algorithm: algorithm, option: option, keyData: keyData, keyLength: keyLength, stringData: stringData){
//            return String(data: result, encoding: .utf8)
//        }else{
//            return nil
//        }
//    }



    func trim(_ charset:CharacterSet = CharacterSet.whitespacesAndNewlines) -> Base {
        return self.base.trimmingCharacters(in: charset) 
    }

    func isEmpty(needTrim:Bool = true) -> Bool{
        if needTrim {
            return self.trim().characters.count == 0
        }else{
            return self.base.characters.count == 0
        }
    }

    func substring(_ start:Int, _ end:Int? = nil) -> String {
        let str = self.base
        let startIndex = str.index(str.startIndex, offsetBy: start)

        if let end = end {
            let endIndex = str.index(str.startIndex, offsetBy: end)
            return String(str[startIndex...endIndex])
        }else{
            return String(str[startIndex...])
        }
    }
}


//MARK:- textField
extension CLExtension where Base:UITextField{
    func setLeftImageView(imageName:String,extraWidth:CGFloat) {
        var leftView = UIImageView(image: UIImage(named: imageName))
        leftView.contentMode = .center
        leftView.cl.width += extraWidth
        self.base.leftView = leftView
        self.base.leftViewMode = .always
    }
}
//MARK:- UIColor
extension CLExtension where Base: UIColor{
    func getRGBA()->(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha :CGFloat = 0
        self.base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red,green,blue,alpha)
    }
    
    class func fromHex(_ hex:String) -> UIColor {
        if let (red,green,blue) = hex.cl.RGB{
            return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
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

//MARK:- DateFormatter
extension CLExtension where Base: DateFormatter{
    
    class func formatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
}

extension CLExtension where Base:UIImage {
    class func formColor(_ color:UIColor,
                         _ size:CGSize,
                         borderWidth:CGFloat? = nil,
                         borderColor:UIColor? = nil,
                         cornerType:UIRectCorner = .allCorners,
                         cornerRadio:CGFloat = 0,
                         needResizeable:Bool = false) -> UIImage?{
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        let cornerRadioSize = CGSize(width:cornerRadio,height:cornerRadio)
        let cornerClip = UIBezierPath(roundedRect: rect, byRoundingCorners: cornerType , cornerRadii: cornerRadioSize)
        cornerClip.addClip()
        context?.addPath(cornerClip.cgPath)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        if let bWidth = borderWidth,bWidth > 0,let bColor = borderColor{
            let borderPath = UIBezierPath(roundedRect: rect, byRoundingCorners: cornerType, cornerRadii: cornerRadioSize)
            context?.addPath(borderPath.cgPath)
            context?.setLineWidth(bWidth)
            context?.setLineCap(.round)
            context?.setStrokeColor(bColor.cgColor)

            context?.strokePath()
        }

        var image = UIGraphicsGetImageFromCurrentImageContext()
        if (needResizeable && size.width > 1 && size.height > 1){
            let offset = ceil(borderWidth ?? 0) + cornerRadio + 1;
            let edge = UIEdgeInsetsMake(offset, offset, offset, offset)
            image = image?.resizableImage(withCapInsets: edge,resizingMode:.stretch)
        }

        UIGraphicsEndImageContext()
        return image;
    }
    
    func jpgData(maxLength:Int) ->Data?{
        var level:CGFloat = 1
        var data = UIImageJPEGRepresentation(self.base, level)
        while let size = data?.count,
            size > maxLength,
            level > 0.01 {
                level -= 0.01
                data = UIImageJPEGRepresentation(self.base, level)
        }
        return data
    }
    func jpgData(maxLength:Int,complate:@escaping ((Data?)->())){
        DispatchQueue.global().async {
            let data = self.jpgData(maxLength: maxLength)
            DispatchQueue.main.async {
                complate(data)
            }          
        }
    }
    class func resizableImageWith(imageName: String) -> UIImage {
        let oldImage = UIImage.init(named: imageName)
        let w: CGFloat = (oldImage?.size.width)! * 0.5
        let t: CGFloat = (oldImage?.size.height)! * 0.75
        let b: CGFloat = (oldImage?.size.height)! * 0.25
        let newImage = oldImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(t, w, b, w), resizingMode: .stretch)
        return newImage!
    }
   

}

extension NSObject:CLExtensionCompatible{}
extension String:CLExtensionCompatible {}
extension CLExtension where Base: NSDate{
    class func stringOfCurrentDate() -> String {
        let formater = DateFormatter.init()
        formater.dateFormat = "yyyyMMddHHmmssSSS"
        return formater.string(from: NSDate() as Date)
    }
}


