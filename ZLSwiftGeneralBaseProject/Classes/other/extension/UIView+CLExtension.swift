//
//  UIView+CLExtension.swift
//  ZHDJ
//
//  Created by liuchang on 2017/4/14.
//  Copyright © 2017年 com.akira. All rights reserved.
//

import UIKit

extension CLExtension where Base: UIView {

    class func formXIB() -> Base {
        let className = String(describing: Base.self)
        
        let xib = Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.first
        let view = xib as! Base

        let size = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        view.frame = CGRect(origin: CGPoint(x:0,y:0), size: size)
        return view
    }
    
    func bubbleAnimation() {
        self.bubbleAnimation(scaleSequence: [0.8, 1.2, 1], duration: 0.3)
    }
    
    func bubbleAnimation(scaleSequence: [CGFloat], duration: TimeInterval) {
        let countAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        countAnim.values = scaleSequence
        countAnim.duration = duration
        self.base.layer.add(countAnim, forKey: nil)
    }
    
    func fadeWithDuration(duration: TimeInterval) {
        CATransition.cl.startFadeTransition(on: self.base, duration: duration, key: nil)
    }
    
}
