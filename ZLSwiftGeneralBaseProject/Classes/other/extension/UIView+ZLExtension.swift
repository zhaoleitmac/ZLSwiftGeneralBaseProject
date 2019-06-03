//
//  UIView+ZLExtension.swift
//  ZHDJ
//
//  Created by liuchang on 2017/4/14.
//  Copyright © 2017年 com.akira. All rights reserved.
//

import UIKit

extension ZLExtension where Base: UIView {
    
    class func fromXIB(nibName: String? = nil) -> Base {
        let xib = Bundle.main.loadNibNamed(nibName ?? String(describing: Base.self), owner: nil, options: nil)?.first
        let view = xib as! Base
        
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        view.frame = CGRect(origin: CGPoint(x:0,y:0), size: size)
        return view
    }
    
    func bubbleAnimation(scaleSequence: [CGFloat] = [0.8, 1.2, 1], duration: TimeInterval = 0.3) {
        let countAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        countAnim.values = scaleSequence
        countAnim.duration = duration
        self.base.layer.add(countAnim, forKey: nil)
    }
    
    func fade(with duration: TimeInterval = TimeInterval.animationInterval, completion: ((Bool) -> Void)? = nil) {
        CATransition.zl.startFadeTransition(on: self.base, duration: duration, key: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            if let completion = completion {
                completion(true)
            }
        }
    }
    
    func circle(with duration: TimeInterval = 1, isClockwise: Bool = true) {
        self.base.transform = CGAffineTransform.identity
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.toValue = isClockwise ? 2 * Double.pi : -2 * Double.pi
        rotationAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        rotationAnim.repeatCount = .infinity
        rotationAnim.duration = duration
        self.base.layer.add(rotationAnim, forKey: "rotation")
    }
    
    func endAnimation() {
        self.base.layer.removeAllAnimations()
        self.base.transform = CGAffineTransform.identity

    }
    
    
    func renderImage() -> UIImage? {

        let view = self.base
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
        }
        let renderImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return renderImage
    }
    
    
    class var identifier: String {return String(describing: Base.self)}

}

//MARK:- View frames about
extension ZLExtension where Base: UIView {
    
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
    public var origin:CGPoint{
        get{
            return self.base.frame.origin
        }
        set{
            self.base.frame.origin = newValue
        }
    }
    public var size:CGSize{
        get{
            return self.base.frame.size
        }
        set{
            self.base.frame.size = newValue
        }
    }
}
