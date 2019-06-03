//
//  CATransition+ZLExtension.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/9.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

extension ZLExtension where Base: CATransition {

    class func startTransitionAniamtion(on view: UIView, type: String, subType: String?, duration: TimeInterval, key: String?) {
        let transition = self.transition(type: type, subType: subType, duration: duration, key: key)
        view.layer.add(transition, forKey: key)
    }

    class func transition(type: String, subType: String?, duration: TimeInterval, key: String?) -> CATransition {
        
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType(rawValue: type)
        transition.subtype = subType.map { CATransitionSubtype(rawValue: $0) }
        return transition;
    }
    
    class func startFadeTransition(on view: UIView, duration: TimeInterval, key: String?) {
        self.startTransitionAniamtion(on: view, type: CATransitionType.fade.rawValue, subType: nil, duration: duration, key: key)
    }
    
}
