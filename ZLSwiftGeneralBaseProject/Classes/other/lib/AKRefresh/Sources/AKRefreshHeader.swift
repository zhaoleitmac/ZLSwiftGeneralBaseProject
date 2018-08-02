//
//  AKRefershHeader.swift
//  AKRefresh
//
//  Created by liuchang on 2016/12/1.
//  Copyright © 2016年 com.unknown. All rights reserved.
//

import UIKit

open class AKRefreshHeader: AKRefreshView {
    open static let DEFAULT_HEIGHT : CGFloat = 60

    override public init(height:CGFloat = DEFAULT_HEIGHT,indicator:AKRefreshIndicator,action:@escaping (()->())) {
        var adjustHeight = height
        if adjustHeight == 0 {
            adjustHeight = type(of:self).DEFAULT_HEIGHT
        }
        super.init(height:adjustHeight,indicator: indicator,action:action)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func progressWithScrollViewInsets(_ insets: UIEdgeInsets, offset: CGPoint) -> CGFloat {
        let willShowOffsetY = -self.scrollViewOriginalInsets.top
        let currentOffsetY = offset.y
        if (currentOffsetY >= willShowOffsetY) {
            return -1
        }else{
            let progress = (currentOffsetY - willShowOffsetY) / -self.frame.height;
            return progress
        }
    }
    open override func willShowAtPoint() -> CGPoint{
        return CGPoint(x:0,y:-self.scrollViewOriginalInsets.top - self.frame.height)
    }

    open override func refreshViewChangeUIWhenFinish(_ refreshView: AKRefreshViewType) {
        super.refreshViewChangeUIWhenFinish(refreshView)
        if (self.scrollViewOriginalInsets.top == 0) {
            self.scrollView?.contentInset.top = 0;
        }else if (self.scrollViewOriginalInsets.top == self.scrollView?.contentInset.top ?? 0){
            self.scrollView?.contentInset.top -= self.frame.height;
        }else{
            self.scrollView?.contentInset.top = self.scrollViewOriginalInsets.top;
        }
    }

    open override func refreshViewChangeUIWhenLoading(_ refreshView: AKRefreshViewType) {
        self.scrollView?.bounces = false
        super.refreshViewChangeUIWhenLoading(refreshView)
        let top = self.scrollViewOriginalInsets.top + self.frame.height
        let animateDuration = AKRefreshView.AnimationDuration.normal.rawValue
        UIView.animate(withDuration: animateDuration, animations: {
            self.scrollView?.contentInset.top = top
        }, completion: {finish in
            self.scrollView?.bounces = true
            self.scrollView?.setContentOffset(CGPoint(x: 0, y: -top), animated: true)
            if let action = self.refreshAction{
                action()
            }
        })
    }
}
