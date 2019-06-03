//
//  PopupWraperView.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/9.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum PopupWraperViewStatus {
    
    case initalComplete
    case beforeShow(contentView: UIView, wrapperBounds: CGRect)
    case showAnimation(contentView: UIView, wrapperBounds: CGRect)
    case showFinish(contentView: UIView, wrapperBounds: CGRect)
    case beforeHide(contentView: UIView, wrapperBounds: CGRect)
    case hideAnimation(contentView: UIView, wrapperBounds: CGRect)
    case hideFinish(contentView: UIView, wrapperBounds: CGRect)

}

class PopupWraperView: UIView {

    private let wrapperDuration: TimeInterval = 0.2
    private let contentDuration: TimeInterval = 0.25

    var touchHide = true

    var statusDriver: Driver<PopupWraperViewStatus>!
    
    private var statusVariable = Variable(PopupWraperViewStatus.initalComplete)
    private let disposeBag = DisposeBag()

    private weak var contentView: UIView!
    private var showing = false

    func isShow() -> Bool {
        return self.showing
    }
    
    func getContentView() -> UIView {
        return self.contentView
    }
    
    init(contentView: UIView, frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentView)
        self.contentView = contentView
        self.setupView()
        self.bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    private func setupView() {
        self.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.subscribe(onNext: {[weak self] _ in
            self?.hide()
        }).disposed(by: self.disposeBag)
    }
    
    private func bindData() {
        self.statusDriver = self.statusVariable.asDriver()
        
    }
    
    func show(on view: UIView, needBobble: Bool = false, completion: ((_ finished: Bool) -> ())? = nil) {
        if !showing {
            if self.superview != nil {
                self.showing = true
                var wrapperFrame = view.bounds
                if #available(iOS 11.0, *) {
                    wrapperFrame.size.height -= view.safeAreaInsets.bottom
                }
                self.frame = wrapperFrame
                self.statusVariable.value = .beforeShow(contentView: self.contentView, wrapperBounds: self.bounds)
                self.contentView.isHidden = false
                let needWrapperAnimation = self.backgroundColor != UIColor.clear
                
                let alpha: CGFloat = needWrapperAnimation ? 0 : 1
                let wrapperDuration: TimeInterval = needWrapperAnimation ? self.wrapperDuration : 0
                self.isHidden = false
                self.alpha = alpha
                view.addSubview(self)
                UIView.animate(withDuration: wrapperDuration, animations: {
                    self.alpha = 1
                }, completion: { _ in
                    UIView.animate(withDuration: self.contentDuration, animations: {
                        self.statusVariable.value = .showAnimation(contentView: self.contentView, wrapperBounds: self.bounds)

                    }, completion: { finished in
                        self.statusVariable.value = .showFinish(contentView: self.contentView, wrapperBounds: self.bounds)
                        
                        if completion != nil {
                            completion!(finished)
                        } else {
                            if needBobble {
                                self.contentView.zl.bubbleAnimation(scaleSequence: [1, 1.2, 1], duration: 0.3)
                            }
                        }
                    })
                })
            }
        } else {
            self.showing = false
        }
    }
    
    func hide(with animation: Bool = true, completion: ((_ popupView: PopupWraperView) -> ())? = nil) {
        if animation {
            if showing {
                self.statusVariable.value = .beforeHide(contentView: self.contentView, wrapperBounds: self.bounds)

                UIView.animate(withDuration: self.contentDuration, animations: {
                    self.statusVariable.value = .hideAnimation(contentView: self.contentView, wrapperBounds: self.bounds)

                }, completion: { _ in
                    self.statusVariable.value = .hideFinish(contentView: self.contentView, wrapperBounds: self.bounds)
                    self.contentView.isHidden = false
                    self.contentView.transform = .identity
                    let needWrapperAnimation = self.backgroundColor != UIColor.clear
                    if needWrapperAnimation {
                        self.removeFromSuperview()
                        self.showing = false
                        if completion != nil {
                            completion!(self)
                        }
                    } else {
                        UIView.animate(withDuration: self.wrapperDuration, animations: {
                            self.alpha = 0
                        }, completion: { _ in
                            self.isHidden = true
                            self.showing = false
                            self.removeFromSuperview()
                            if completion != nil {
                                completion!(self)
                            }
                        })
                    }
                })
            } else {
                self.showing = false
                self.contentView.transform = .identity
                self.removeFromSuperview()
                if completion != nil {
                    completion!(self)
                }
            }
        } else {
            self.showing = false
            self.contentView.transform = .identity
            self.removeFromSuperview()
            if completion != nil {
                completion!(self)
            }
        }
    }
    
}
