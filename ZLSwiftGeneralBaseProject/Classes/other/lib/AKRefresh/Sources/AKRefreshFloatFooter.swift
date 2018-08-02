//
//  AKRefershFloatFooter.swift
//  AKRefresh
//
//  Created by liuchang on 2016/12/2.
//  Copyright © 2016年 com.unknown. All rights reserved.
//

import UIKit

open class AKRefreshFloatFooter: AKRefreshFooter {
    public override init(height: CGFloat = DEFAULT_HEIGHT, indicator: AKRefreshIndicator, action: @escaping (() -> ())) {
        super.init(height: height, indicator: indicator, action: action)
        self.actionButton?.isHidden = true
    }

    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func adjustFrameWhenScrollViewContentSizeChnage() {
        let scrollContentHeight = self.scrollView?.contentSize.height ?? 0
        let scrollViewHeight = (self.scrollView?.frame.height ?? 0) - (self.scrollView?.contentInset.top ?? 0) - (self.scrollView?.contentInset.bottom ?? 0);
        self.isOverScrollView = scrollContentHeight > scrollViewHeight - 10;
        if (!self.isOverScrollView) {
            self.frame.origin.y = scrollViewHeight
        }else{
            self.frame.origin.y = scrollContentHeight;
        }
    }

    override open func progressWithScrollViewInsets(_ insets: UIEdgeInsets, offset: CGPoint) -> CGFloat {
        let willShowOffsetY = self.frame.minY - (self.scrollView?.frame.height ?? 0) + insets.bottom;
        if (offset.y >= willShowOffsetY && self.frame.height != 0) {
            let currentProgress = (offset.y - willShowOffsetY) / self.frame.height;
            return currentProgress;
        }else{
            return -1;
        }
    }

    open override func onIsOverScrollViewChange(oldValue: Bool) {}

    open override func refreshViewChangeUIWhenNormal(_ refreshView: AKRefreshViewType) {
        super.refreshViewChangeUIWhenNormal(refreshView)
        self.actionButton?.isHidden = true
    }

    

}
