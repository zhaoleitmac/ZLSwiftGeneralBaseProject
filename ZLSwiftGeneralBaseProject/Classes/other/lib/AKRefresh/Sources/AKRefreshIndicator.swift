//
//  AKRefreshIndicator.swift
//  AKRefresh
//
//  Created by liuchang on 2016/11/30.
//  Copyright © 2016年 com.unknown. All rights reserved.
//

import UIKit

public protocol AKRefreshIndicatorType{
    var progress : CGFloat {get set}

    func startAnimation()

    func stopAnimation()
}


open class AKRefreshIndicator:UIView,AKRefreshIndicatorType{
    public enum ProgressInterval : CGFloat{
        case min = 0
        case max = 1
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private var currentProgress:CGFloat = 0{
        didSet{
            if(!self.isHidden && self.alpha > 0){
                self.animationWithProgress(currentProgress)
            }
        }
    }
    public var progress: CGFloat {
        get{
            return self.currentProgress
        }
        set {
            if (newValue != self.currentProgress){
                if (newValue > ProgressInterval.max.rawValue){
                    self.currentProgress = ProgressInterval.max.rawValue
                }else if(newValue < ProgressInterval.min.rawValue){
                    self.currentProgress = ProgressInterval.min.rawValue
                }else{
                    self.currentProgress = newValue
                }
            }
        }
    }

    open func animationWithProgress(_ progress:CGFloat){

    }

    open func startAnimation() {
        if (self.isHidden || self.alpha < 0.01) {
            return
        }
    }

    open func stopAnimation() {
        self.layer.removeAllAnimations()
    }
}
