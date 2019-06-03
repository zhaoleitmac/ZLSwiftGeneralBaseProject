//
//  UIImage+ZLExtension.swift
//  YFCB
//
//  Created by 赵雷 on 2018/12/4.
//  Copyright © 2018 缀新网络技术有限公司. All rights reserved.
//

import UIKit

//MARK:- UIImage
extension ZLExtension where Base:UIImage {
    class func fromColor(_ color:UIColor,
                         _ size:CGSize,
                         borderWidth:CGFloat? = nil,
                         borderColor:UIColor? = nil,
                         cornerType:UIRectCorner = .allCorners,
                         cornerRadius:CGFloat = 0,
                         needResizeable:Bool = false) -> UIImage?{
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        let cornerRadiusSize = CGSize(width:cornerRadius,height:cornerRadius)
        let cornerClip = UIBezierPath(roundedRect: rect, byRoundingCorners: cornerType, cornerRadii: cornerRadiusSize)
        cornerClip.addClip()
        context?.addPath(cornerClip.cgPath)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        if let bWidth = borderWidth,bWidth > 0,let bColor = borderColor{
            let borderPath = UIBezierPath(roundedRect: rect, byRoundingCorners: cornerType, cornerRadii: cornerRadiusSize)
            context?.addPath(borderPath.cgPath)
            context?.setLineWidth(bWidth)
            context?.setLineCap(.round)
            context?.setStrokeColor(bColor.cgColor)
            
            context?.strokePath()
        }
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        if (needResizeable && size.width > 1 && size.height > 1){
            let offset = ceil(borderWidth ?? 0) + cornerRadius + 1;
            let edge = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
            image = image?.resizableImage(withCapInsets: edge,resizingMode:.stretch)
        }
        
        UIGraphicsEndImageContext()
        return image;
    }
    
    func jpgData(maxLength:Int) ->Data?{
        var level:CGFloat = 1
        var data = self.base.jpegData(compressionQuality: level)
        while let size = data?.count,
            size > maxLength,
            level > 0.01 {
                level -= 0.01
                data = self.base.jpegData(compressionQuality: level)
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
        let newImage = oldImage?.resizableImage(withCapInsets: UIEdgeInsets(top: t, left: w, bottom: b, right: w), resizingMode: .stretch)
        return newImage!
    }
    
}

extension ZLExtension where Base: UIImage {
    
    func squareImage(blackFill: Bool) -> UIImage {
        let image = self.base
        if image.size.width == image.size.height {
            return image
        } else {
            let length = blackFill ? max(image.size.width, image.size.height) : min(image.size.width, image.size.height)
            UIGraphicsBeginImageContextWithOptions(CGSize(width: length, height: length), _: false, _: 0)
            UIImage.zl.fromColor(UIColor.black, CGSize(width: length, height: length))?.draw(at: CGPoint.zero) //先把黑底画上去
            image.draw(at: CGPoint(x: (length - image.size.width) * 0.5, y: (length - image.size.height) * 0.5))
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
            return image
        }

    }

    func image(scaledTo size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.base.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self.base
        UIGraphicsEndImageContext()
        return image
    }

    func scaled(to newSize: CGSize, withScale: Bool) -> UIImage? {
        var newSize = newSize
        var scale: CGFloat = 1
        if withScale {
            scale = UIScreen.main.scale
        }
        newSize = CGSize(newSize.width * scale, newSize.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, _: false, _: 0)
        self.base.draw(in: CGRect.init(0, 0, newSize.width * scale, newSize.height * scale))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self.base
        UIGraphicsEndImageContext()
        return newImage
    }

    
    class func turnImage(withInfo info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        var image = info[.originalImage] as? UIImage
        //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
        let type = info[.mediaType] as? String
        if (type == "public.image") {
            let imageOrientation: UIImage.Orientation? = image?.imageOrientation
            if imageOrientation != .up {
                // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
                UIGraphicsBeginImageContext(image?.size ?? .zero)
                image?.draw(in: CGRect(x: 0, y: 0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0))
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        return image
    }

    
    func jpegData(maxSize: Int = 1024 * 1024) -> Data? {
        let image = self.base
        var compress: CGFloat = 0.8
        var data = image.jpegData(compressionQuality: compress)
        while data?.count ?? 0 > maxSize, compress > 0.1 {
            compress -= 0.1
            data = image.jpegData(compressionQuality: compress)
        }
        return data
    }
    
    func transparentImage(by alpha: CGFloat) -> UIImage {
        let image = self.base
        UIGraphicsBeginImageContextWithOptions(image.size, _: false, _: 0.0)
        
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -area.size.height)
        
        ctx!.setBlendMode(CGBlendMode.multiply)
        
        ctx?.setAlpha(alpha)
        
        ctx?.draw(image.cgImage!, in: area)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image

    }
    
    class func roundPureImage(color: UIColor, length: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(length, length), _: false, _: 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(0, 0, length, length)
        ctx?.addEllipse(in: rect)
        ctx?.clip()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image ?? UIImage()

       
    }
    
    class func overlap(imageSize: CGSize, below: (image: UIImage, frame: CGRect)?, on: (image: UIImage, frame: CGRect)?) -> UIImage? {
        UIGraphicsBeginImageContext(imageSize)
        if let below = below {
            below.image.draw(in: below.frame)
        }
        if let on = on {
            on.image.draw(in: on.frame)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
