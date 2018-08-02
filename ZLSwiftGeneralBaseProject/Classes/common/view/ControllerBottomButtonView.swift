//
//  ControllerBottomButtonView.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/28.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class ControllerBottomButtonView: UIView {

    private static let height = 60
    
    private static let bgColor = UIColor.white
    
    private static let sepLineColor = UIColor.outSeparator1

    var btnDriver: Driver<Void>!
    
    var bgTransparent: Bool = false {
        didSet {
            self.backgroundColor = bgTransparent ? UIColor.clear : ControllerBottomButtonView.bgColor
            self.topLine.backgroundColor = bgTransparent ? UIColor.clear : ControllerBottomButtonView.sepLineColor
        }
    }
    
    private var button: UIButton!
    
    private var topLine: UIImageView!
    
    class func buttonView(addTo controller: UIViewController) -> ControllerBottomButtonView {
        let buttonView = ControllerBottomButtonView()
        buttonView.backgroundColor = bgColor
        controller.view.addSubview(buttonView)
        buttonView.snp.makeConstraints { (maker) in
            maker.height.equalTo(height)
            maker.left.right.bottom.equalToSuperview()
        }
        let topLine = UIImageView()
        topLine.backgroundColor = sepLineColor
        buttonView.addSubview(topLine)
        topLine.snp.makeConstraints { (maker) in
            maker.height.equalTo(1)
            maker.top.left.right.equalToSuperview()
        }
        buttonView.topLine = topLine
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.appBtnGreen
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        buttonView.addSubview(button)
        buttonView.button = button
        button.snp.makeConstraints { (maker) in
            maker.top.equalTo(buttonView).offset(10);
            maker.left.equalTo(buttonView).offset(20);
            maker.right.equalTo(buttonView).offset(-20);
            maker.height.equalTo(40);
        }
        buttonView.btnDriver = button.rx.tap.asDriver()
        return buttonView
    }

    func setTitle(_ title: String?, for state: UIControlState) {
        self.button.setTitle(title, for: state)
    }
    
    func show() {
        self.snp.updateConstraints { (maker) in
            maker.height.equalTo(ControllerBottomButtonView.height)
        }
    }
    
    func hide() {
        self.snp.updateConstraints { (maker) in
            maker.height.equalTo(0)
        }
    }
}
