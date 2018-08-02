//
//  AlertView.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/9.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum AlertViewBtnType: Int {
    case left = 1
    case right = 2
}

class AlertView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var leftBtn: UIButton!
    @IBOutlet private weak var rightBtn: UIButton!
    @IBOutlet private weak var textFieldHeight: NSLayoutConstraint!
    
    
    var alertModel: AlertViewModel? {
        didSet {
            if let model = alertModel {
                self.titleLabel.text = model.title
                self.titleLabel.textColor = model.titleColor
                self.subTitleLabel.text = model.subTitle
                self.titleLabel.textColor = model.subTitleColor
                
                self.leftBtn.setTitle(model.leftBtnTitle, for: .normal)
                self.leftBtn.setTitleColor(model.leftBtnTitleColor, for: .normal)
                self.leftBtn.backgroundColor = model.leftBtnBGColor
                if model.leftBtnWidth != nil {
                    self.leftBtn.layer.borderWidth = model.leftBtnWidth!
                    self.leftBtn.layer.borderColor = model.leftBtnBorderColor.cgColor
                }
                
                self.rightBtn.setTitle(model.rightBtnTitle, for: .normal)
                self.rightBtn.setTitleColor(model.rightBtnTitleColor, for: .normal)
                self.rightBtn.backgroundColor = model.rightBtnBGColor
                if model.rightBtnWidth != nil {
                    self.rightBtn.layer.borderWidth = model.rightBtnWidth!
                    self.rightBtn.layer.borderColor = model.rightBtnBorderColor.cgColor
                }

            }
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private var frameChange: Disposable?

    var alertBtnDriver: Driver<AlertViewBtnType>!
    
    var textDriver: Driver<String>!

    
    private var alertBtnPublishSubject = PublishSubject<AlertViewBtnType>()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        self.bindData()
    }
    
    
    private func setupView() {
        self.textField.layer.borderWidth = 0.3
        self.textField.leftViewMode = .always
        self.textField.leftView = UIView(frame: CGRect(0, 0, 10, 1))
    }
    
    private func bindData() {
        self.alertBtnDriver = self.alertBtnPublishSubject.asDriver(onErrorJustReturn: .left)
        self.leftBtn.rx.tap.subscribe(onNext: {self.alertBtnPublishSubject.onNext(.left)}).disposed(by: self.disposeBag)
        self.rightBtn.rx.tap.subscribe(onNext: {self.alertBtnPublishSubject.onNext(.right)}).disposed(by: self.disposeBag)
        self.textDriver = self.textField.rx.text.orEmpty.asDriver().map({[weak self] (text) -> String in
            self?.textField.isHidden = text.cl.length == 0
            self?.textFieldHeight.constant = text.cl.length == 0 ? 0 : 35
            return text
        })
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if self.superview != nil {
            self.frameChange?.dispose()
        }
        if let superview = newSuperview {
            self.frameChange = superview.rx.observe(CGRect.self, "frame").subscribe(onNext: {[weak self] (frame) in
                self?.updateFrame(superviewFrame: frame ?? .zero)
            })
            self.updateFrame(superviewFrame: superview.frame)
        }
    }

    public func updateFrame(superviewFrame: CGRect) {
        let size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let width = size.width
        let height = size.height
        let x = (superviewFrame.width - width) * 0.5
        let y = (superviewFrame.height - height) * 0.5
        self.frame = CGRect(x, y, width, height)
    }
    
}

struct AlertViewModel {
    
    var title = "Title"
    var titleColor = UIColor.fontBlack1
    var subTitle = "subTitle"
    var subTitleColor = UIColor.fontBlack1

    var leftBtnTitle = "考虑一下"
    var leftBtnTitleColor = UIColor.white
    var leftBtnBGColor = UIColor.cl.fromRGBA(242, 85, 85)
    var leftBtnBorderColor = UIColor.cl.fromRGBA(242, 85, 85)
    var leftBtnWidth: CGFloat? = nil
    
    var rightBtnTitle = "确定取消"
    var rightBtnTitleColor = UIColor.fontBlack1
    var rightBtnBGColor = UIColor.white
    var rightBtnBorderColor = UIColor.cl.fromRGBA(214, 214, 214, 0.56)
    var rightBtnWidth: CGFloat? = nil
    
    static func defaultModel() -> AlertViewModel {
        var model = AlertViewModel()
        model.rightBtnWidth = 0.3
        return model
    }
}
