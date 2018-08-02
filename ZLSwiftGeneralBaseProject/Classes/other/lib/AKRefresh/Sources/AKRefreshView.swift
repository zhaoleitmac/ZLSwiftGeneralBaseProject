//
//  AKRefreshView.swift
//  AKRefresh
//
//  Created by liuchang on 2016/11/30.
//  Copyright © 2016年 com.unknown. All rights reserved.
//

import UIKit
public enum AKRefreshViewStatus:Int {
    case normal = 1
    case willLoading = 2
    case loading = 3
}

public protocol AKRefreshViewControl{
    func refreshViewChangeUIWhenNormal(_ refreshView:AKRefreshViewType)
    func refreshViewChangeUIWhenWillLoading(_ refreshView:AKRefreshViewType)
    func refreshViewChangeUIWhenLoading(_ refreshView:AKRefreshViewType)
    func refreshViewChangeUIWhenFinish(_ refreshView:AKRefreshViewType)
}
public protocol AKRefreshViewType{
    //        associatedtype baseView
    var scrollView : UIScrollView?{get}
    var scrollViewOriginalInsets : UIEdgeInsets {get}
    var refreshAction : (()->())! {get set}
    var status : AKRefreshViewStatus {get set}
    var previousState : AKRefreshViewStatus {get}
    var indicator:AKRefreshIndicator?{get set}
    var progress : CGFloat {get}

    func endRefresh(complete:((AKRefreshViewType)->())?)

    func startRefresh()
    /**
     *  根据scrollView的属性计算出空间将要显示的位置
     *
     *  @param scrollViewInsets scrollView 原始的 contentInsets
     *  @param offset           scrollView 当前(滚动时)的 contentOffset
     *
     *  @return 控件显示的百分比进度，如果控件直接处于屏幕外，返回-1,父类默认返回-1
     */
    func progressWithScrollViewInsets(_ insets:UIEdgeInsets,offset:CGPoint) -> CGFloat
    /**
     *  控件将要显示的位置，由Header子类实现,Footer子类此方法无意义
     *
     *  @return 控件刚加入 scrollView 时将要显示的位置，默认返回(0,0)
     */
    func willShowAtPoint() -> CGPoint
}



open class AKRefreshView :UIControl,AKRefreshViewType,AKRefreshViewControl{
    private var refreshComplete:((AKRefreshViewType)->())?
    public var hideWhenComplate = false
    public enum AnimationDuration:TimeInterval{
        case none = 0
        case normal = 0.25
        case fast = 0.1
    }
    public enum KVOPath:String{
        case scrollViewContentOffsetPath = "contentOffset"
        case scrollViewContentSizePath = "contentSize"
    }

    private weak var pScrollView:UIScrollView?

    private var pScrollViewOriginalInsets:UIEdgeInsets = .zero

    private var pPreviousState:AKRefreshViewStatus = .normal

    public var scrollView: UIScrollView?{
        return self.pScrollView
    }

    public var scrollViewOriginalInsets: UIEdgeInsets{
        return self.pScrollViewOriginalInsets
    }
    open var status: AKRefreshViewStatus = .normal{
        didSet{
            if (status == oldValue) {return}
            self.pPreviousState = oldValue
            self.onStateChange()
        }
    }

    public var previousState: AKRefreshViewStatus{
        return self.pPreviousState
    }
    public var refreshAction: (() -> ())!

    public weak var indicator: AKRefreshIndicator?{
        willSet{
            if let newIndicator = newValue{
                self.addSubview(newIndicator)
            }
        }
        didSet{
            if let oldIndicator = oldValue{
                self.indicator?.progress = oldIndicator.progress
                oldIndicator.removeFromSuperview()
            }
        }
    }

    public var progress: CGFloat{
        return self.indicator?.progress ?? 0
    }
    public init(height:CGFloat, indicator:AKRefreshIndicator,action:@escaping (()->())) {
        var frame = CGRect.zero
        frame.size.height = height
        super.init(frame: frame)
        self.autoresizingMask = .flexibleWidth
        if(indicator.superview != self){
            self.addSubview(indicator)
        }
        self.indicator = indicator
        self.refreshAction = action
        self.backgroundColor = UIColor.clear
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        let offsetKeyPath = AKRefreshView.KVOPath.scrollViewContentOffsetPath.rawValue
        self.superview?.removeObserver(self, forKeyPath: offsetKeyPath)

        if let newView = newSuperview {
            newView.addObserver(self, forKeyPath: offsetKeyPath, options: .new, context: nil)
            self.frame.size.width = newView.frame.size.width
            self.frame.origin = self.willShowAtPoint()
            self.pScrollView = newView as? UIScrollView
            self.pScrollView?.alwaysBounceVertical = true
            self.pScrollViewOriginalInsets = self.pScrollView?.contentInset ?? .zero
        }
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (self.status == .loading) {return}
        if (AKRefreshView.KVOPath.scrollViewContentOffsetPath.rawValue == keyPath) {
            if (!self.isUserInteractionEnabled
                || self.isHidden
                || self.alpha < 0.01) {
                return
            }
            self.adjustState()
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }

    }
    open func onStateChange(){
        if (self.previousState != .loading) {
            self.pScrollViewOriginalInsets = self.scrollView?.contentInset ?? .zero
        }
        if (self.status == .normal) {
            if (self.previousState == .loading) {
                self.indicator?.stopAnimation()
                self.indicator?.progress = AKRefreshIndicator.ProgressInterval.min.rawValue
                self.indicator?.isHidden = true
                UIView.animate(withDuration: AKRefreshView.AnimationDuration.normal.rawValue, animations: {
                    self.refreshViewChangeUIWhenFinish(self)
                }, completion: { (finished) in
                    self.indicator?.isHidden = false
                    self.refreshViewChangeUIWhenNormal(self)
                    self.refreshComplete?(self)
                    self.isHidden = self.hideWhenComplate
                })
            } else{
                self.refreshViewChangeUIWhenNormal(self)
            }
        }else if(self.status == .willLoading){
            self.refreshViewChangeUIWhenWillLoading(self)
        }else if(self.status == .loading){
            self.indicator?.isHidden = false
            self.indicator?.progress = AKRefreshIndicator.ProgressInterval.max.rawValue
            self.indicator?.startAnimation()
            self.refreshViewChangeUIWhenLoading(self)

        }
    }

    open func adjustState(){
        if (self.window == nil) {return}

        let progress = self.progressWithScrollViewInsets(self.scrollViewOriginalInsets, offset: self.scrollView?.contentOffset ?? .zero)
        if (progress == -1) {
            if self.indicator?.progress != 0 {
                self.indicator?.progress = 0
            }
            return
        }
        
        if let scrollView = self.scrollView {
            if (scrollView.isDragging){
                //未松手
                self.indicator?.progress = progress
                let critical = AKRefreshIndicator.ProgressInterval.max.rawValue
                if (progress >= critical && self.status == .normal) {
                    self.status = .willLoading
                }else if(progress < critical && self.status == .willLoading){
                    self.status = .normal
                }
            }else{
                //松手
                if (self.status == .willLoading) {
                    self.status = .loading
                }else if(self.status == .normal){
                    self.indicator?.progress = progress
                }
            }
        }
    }


    open func endRefresh(complete:((AKRefreshViewType)->())? = nil) {
        self.status = .normal
        self.refreshComplete = complete
    }

    @objc open func startRefresh() {
        if let _ = self.window{
            self.status = .loading
        }else{
            //还未在view上出现，延迟到drawRect中处理
            self.status = .willLoading
        }
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if (self.status == .willLoading) {
            self.startRefresh()
        }else{
            self.status = .normal
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        if (self.status != .loading) {
            let insets = self.scrollView?.contentInset ?? .zero
            if self.scrollViewOriginalInsets != insets{
                self.pScrollViewOriginalInsets = insets
                self.adjustState()
            }
        }
    }
    open func progressWithScrollViewInsets(_ insets: UIEdgeInsets, offset: CGPoint) -> CGFloat {
        return -1
    }

    open func willShowAtPoint() -> CGPoint {
        return .zero
    }
    open func refreshViewChangeUIWhenNormal(_ refreshView: AKRefreshViewType) {

    }

    open func refreshViewChangeUIWhenWillLoading(_ refreshView: AKRefreshViewType) {

    }

    open func refreshViewChangeUIWhenLoading(_ refreshView: AKRefreshViewType) {
        
    }
    open func refreshViewChangeUIWhenFinish(_ refreshView: AKRefreshViewType) {
        
    }
    
    
    
}


