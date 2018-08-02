//
//  AKRefreshAutoFooter.swift
//  AKRefresh
//
//  Created by liuchang on 2016/12/2.
//  Copyright © 2016年 com.unknown. All rights reserved.
//

import UIKit

open class AKRefreshAutoFooter: AKRefreshFooter {
    public var autoTriggerEnable:Bool = true{
        didSet{
            self.onAutoTriggerEnableChange(oldValue: oldValue)
        }
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
            return
        }
        if (keyPath == AKRefreshView.KVOPath.scrollViewContentSizePath.rawValue) {
            self.adjustFrameWhenScrollViewContentSizeChnage()
        }else if (keyPath == AKRefreshView.KVOPath.scrollViewContentOffsetPath.rawValue){
            if (self.status == .loading) {
                return;
            }else{
                self.adjustState()
            }
        }
    }

    open override func adjustState() {
        if (self.window == nil) {
            //未在window上画出，直接返回
            return;
        }
        let currentProgress = self.progressWithScrollViewInsets(self.scrollViewOriginalInsets, offset: self.scrollView?.contentOffset ?? .zero )
        if (currentProgress == -1) {
            return;
        }
//        self.indicator?.progress = currentProgress;
        if (currentProgress >= AKRefreshIndicator.ProgressInterval.max.rawValue) {
            self.status = .loading;
        }
    }

    open func onAutoTriggerEnableChange(oldValue:Bool){
        self.actionButton?.isEnabled = autoTriggerEnable
    }

    open override func progressWithScrollViewInsets(_ insets: UIEdgeInsets, offset: CGPoint) -> CGFloat {
        let willShowOffsetY = self.frame.minY - (self.scrollView?.frame.height ?? 0) + insets.bottom - self.frame.height;
        if (offset.y >= willShowOffsetY
            && self.frame.height != 0
            && self.isOverScrollView
            && self.autoTriggerEnable) {
            return AKRefreshIndicator.ProgressInterval.max.rawValue;
        }else{
            return -1;
        }
    }
    open override func onIsOverScrollViewChange(oldValue: Bool) {
        if (self.status != .loading && self.autoTriggerEnable) {
            self.actionButton?.isHidden = isOverScrollView;
            self.indicator?.isHidden = !isOverScrollView;
        }
    }

    open override func refreshViewChangeUIWhenNormal(_ refreshView: AKRefreshViewType) {
        super.refreshViewChangeUIWhenNormal(refreshView)
        self.indicator?.isHidden = true
        if(!self.autoTriggerEnable
            || !self.isOverScrollView){
            self.actionButton?.isHidden = false;
            self.actionButton?.setTitle(type(of:self).DEFAULT_REFRESH_BUTTON_TITLE, for: .normal)
        }
    }
    open override func refreshViewChangeUIWhenWillLoading(_ refreshView: AKRefreshViewType) {}
    open override func refreshViewChangeUIWhenLoading(_ refreshView: AKRefreshViewType) {
        self.actionButton?.isHidden = true
        if let action = self.refreshAction{
            action()
        }
    }
    open override func refreshViewChangeUIWhenFinish(_ refreshView: AKRefreshViewType) {}

    open override func draw(_ rect: CGRect) {
        self.scrollView?.contentInset.bottom = self.scrollViewOriginalInsets.bottom + self.frame.height
        super.draw(rect)
    }
}
