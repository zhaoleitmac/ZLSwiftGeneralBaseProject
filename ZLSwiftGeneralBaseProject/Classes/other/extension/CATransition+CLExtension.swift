//
//  CATransition+CLExtension.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/9.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

extension CLExtension where Base: CATransition {

    class func startTransitionAniamtion(on view: UIView, type: String, subType: String?, duration: TimeInterval, key: String?) {
        let transition = self.transition(type: type, subType: subType, duration: duration, key: key)
        view.layer.add(transition, forKey: key)
    }

    class func transition(type: String, subType: String?, duration: TimeInterval, key: String?) -> CATransition {
        
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.subtype = subType
        return transition;
    }
    
    class func startFadeTransition(on view: UIView, duration: TimeInterval, key: String?) {
        self.startTransitionAniamtion(on: view, type: kCATransitionFade, subType: nil, duration: duration, key: key)
    }
    
}
