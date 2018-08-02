//
//  AKRefreshFooter.swift
//  AKRefresh
//
//  Created by liuchang on 2016/12/2.
//  Copyright © 2016年 com.unknown. All rights reserved.
//

import UIKit

open class AKRefreshFooter: AKRefreshView {
    open static let DEFAULT_HEIGHT:CGFloat = 40
    open static let DEFAULT_REFRESH_BUTTON_TITLE = "加载更多"


    public var isOverScrollView = false{
        didSet{
            self.onIsOverScrollViewChange(oldValue: oldValue)
        }
    }
    public weak var actionButton:UIButton?{
        willSet{
            if let newButton = newValue{
                newButton.addTarget(self, action: #selector(startRefresh), for: .touchUpInside)
                self.addSubview(newButton)
            }
        }
        didSet{
            if let oldButton = oldValue{
                oldButton.removeFromSuperview()
            }
        }
    }

    public override init(height: CGFloat = DEFAULT_HEIGHT, indicator: AKRefreshIndicator, action: @escaping (() -> ())) {
        var adjustHeight = height
        if adjustHeight == 0{
            adjustHeight = type(of:self).DEFAULT_HEIGHT
        }
        super.init(height: adjustHeight, indicator: indicator, action: action)
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitle(type(of:self).DEFAULT_REFRESH_BUTTON_TITLE, for: .normal)
        button.addTarget(self, action: #selector(startRefresh), for: .touchUpInside)
        self.addSubview(button)
        self.actionButton = button
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open func onIsOverScrollViewChange(oldValue:Bool){
        if self.status != .loading {
            self.actionButton?.isHidden = isOverScrollView
            self.indicator?.isHidden = !isOverScrollView
        }
    }
    open func endRefreshAfterMessage(_ message:String,duration:TimeInterval){
        self.indicator?.isHidden = true
        let title = self.actionButton?.title(for: .normal)

        self.actionButton?.setTitle(message, for: .normal)

        self.actionButton?.isHidden = false
        self.actionButton?.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
            UIView.animate(withDuration: 1, animations: { 
                self.actionButton?.alpha = 0
            }, completion: { (finish) in
                self.endRefresh()
                UIView.animate(withDuration: 0.3, animations: {
                    self.actionButton?.alpha = 1
                })
                self.actionButton?.setTitle(title, for: .normal)
                self.actionButton?.isUserInteractionEnabled = true
            })
        })
    }
    open func adjustFrameWhenScrollViewContentSizeChnage(){
        let contentHeight = self.scrollView?.contentSize.height ?? 0
        let scrollViewHeight = (self.scrollView?.frame.height ?? 0) - self.scrollViewOriginalInsets.top - self.scrollViewOriginalInsets.bottom
        self.frame.origin.y = contentHeight
        self.isOverScrollView = contentHeight > scrollViewHeight
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let superView = self.superview {
            superView.removeObserver(self, forKeyPath: AKRefreshView.KVOPath.scrollViewContentSizePath.rawValue)
        }
        if let superView = newSuperview{
            if let tableView = superView as? UITableView{
                if (tableView.tableFooterView?.frame.height ?? 0 < 0.01){
                    let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
                    emptyView.backgroundColor = UIColor.clear
                    tableView.tableFooterView = emptyView
                }
            }
            superView.addObserver(self, forKeyPath: AKRefreshView.KVOPath.scrollViewContentSizePath.rawValue, options: .new, context: nil)
            self.adjustFrameWhenScrollViewContentSizeChnage()
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == AKRefreshView.KVOPath.scrollViewContentSizePath.rawValue {
            if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
                return;
            }
            self.adjustFrameWhenScrollViewContentSizeChnage()
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    open override func progressWithScrollViewInsets(_ insets: UIEdgeInsets, offset: CGPoint) -> CGFloat {
        let willShowOffsetY = self.frame.minY - (self.scrollView?.frame.height ?? 0)  + insets.bottom
        if (offset.y >= willShowOffsetY && self.frame.height != 0 && self.isOverScrollView) {
            let currentProgress = (offset.y - willShowOffsetY) / self.frame.height
            return currentProgress;
        }else{
            return -1;
        }
    }

    open override func refreshViewChangeUIWhenNormal(_ refreshView: AKRefreshViewType) {
        super.refreshViewChangeUIWhenNormal(refreshView)
        self.adjustFrameWhenScrollViewContentSizeChnage()
    }

    open override func refreshViewChangeUIWhenLoading(_ refreshView: AKRefreshViewType) {
        super.refreshViewChangeUIWhenLoading(refreshView)
        self.actionButton?.isHidden = true
        self.scrollView?.bounces = false
        UIView.animate(withDuration: AKRefreshView.AnimationDuration.fast.rawValue, animations: {
            let bottom = self.frame.height + self.scrollViewOriginalInsets.bottom
            self.scrollView?.contentInset.bottom = bottom
        }, completion: {finish in
            self.scrollView?.bounces = true
            let bottomOffset = (self.scrollView?.contentSize.height ?? 0) +  (self.scrollView?.contentInset.bottom ?? 0) - (self.scrollView?.frame.height ?? 0)
            if(bottomOffset > 0){
                self.scrollView?.setContentOffset(CGPoint(x:0,y:bottomOffset), animated: true)
            }
            if let action = self.refreshAction{
                action()
            }
        })
    }

    open override func refreshViewChangeUIWhenFinish(_ refreshView: AKRefreshViewType) {
        super.refreshViewChangeUIWhenFinish(refreshView)
        self.scrollView?.contentInset.bottom = self.scrollViewOriginalInsets.bottom
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.actionButton?.frame = self.bounds
    }

}
