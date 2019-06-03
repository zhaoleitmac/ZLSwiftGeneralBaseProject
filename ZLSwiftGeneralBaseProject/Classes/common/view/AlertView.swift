//
//  AlertView.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/9.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

class AlertView: UIView {

    enum AlertViewStyle: Int {
        case grayLeft = 0
        case grayRight = 1
    }
    
    var leftAction: (() -> ())?
    var rightAction: (() -> ())?
    
    var title: String {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text ?? ""
        }
    }
    
    var detailText: String {
        set {
            detailLabel.text = newValue
        }
        get {
            return detailLabel.text ?? ""
        }
    }
    
    var leftTitle: String {
        set {
            leftBtn.setTitle(newValue, for: .normal)
        }
        get {
            return leftBtn.currentTitle ?? ""
        }
    }
    
    var rightTitle: String {
        set {
            rightBtn.setTitle(newValue, for: .normal)
        }
        get {
            return rightBtn.currentTitle ?? ""
        }
    }
    
    
    var style: AlertViewStyle = .grayLeft {
        didSet {
            switch style {
            case .grayLeft:
                self.leftBtn.setTitleColor(UIColor.zl.fromHex("666666"), for: .normal)
                self.rightBtn.setTitleColor(UIColor.zl.fromHex("007AFF"), for: .normal)
            case .grayRight:
                self.leftBtn.setTitleColor(UIColor.zl.fromHex("007AFF"), for: .normal)
                self.rightBtn.setTitleColor(UIColor.zl.fromHex("666666"), for: .normal)
            }
        }
    }
    
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    @IBOutlet private weak var leftBtn: UIButton!
    @IBOutlet private weak var rightBtn: UIButton!
    
    
    class func alertView() -> AlertView {
        let alertView = self.zl.fromXIB()
        return alertView
    }
    
     func show(in view: UIView = UIApplication.shared.keyWindow!) {
        for subview in view.subviews {
            if type(of: subview) == type(of: self) {
                subview.removeFromSuperview()
            }
        }
        view.addSubview(self)
        self.snp.makeConstraints{$0.edges.equalToSuperview()}
        self.contentView.zl.bubbleAnimation()
    }

    func hide() {
        self.isHidden = true
        self.removeFromSuperview()
    }
    
    @IBAction func leftBtnClicked() {
        self.hide()
        if let leftAction = self.leftAction {
            leftAction()
        }
    }
    
    @IBAction func rightBtnClicked() {
        self.hide()
        if let rightAction = self.rightAction {
            rightAction()
        }
    }
}

