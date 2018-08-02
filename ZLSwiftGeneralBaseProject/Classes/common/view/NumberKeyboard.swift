//
//  NumberKeyboard.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/13.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NumberKeyboard: UIView {
    
    private let disposeBag = DisposeBag()
    
    var input = PublishSubject<NumberKeyboardClickType>()
    
    private weak var titleLabel: UILabel?
    private weak var leftLable: UILabel?
    
    private weak var deleteBtn: UIButton!
    private weak var oneBtn: UIButton!
    private weak var twoBtn: UIButton!
    private weak var threeBtn: UIButton!
    private weak var fourBtn: UIButton!
    private weak var fiveBtn: UIButton!
    private weak var sixBtn: UIButton!
    private weak var sevenBtn: UIButton!
    private weak var eightBtn: UIButton!
    private weak var nineBtn: UIButton!
    private weak var zeroBtn: UIButton!
    private weak var cancelBtn: UIButton!
    private weak var nextBtn: UIButton!

    private weak var horiLine1: UIImageView!
    private weak var horiLine2: UIImageView!
    private weak var horiLine3: UIImageView!
    private weak var horiLine4: UIImageView!
    private weak var vertiLine1: UIImageView!
    private weak var vertiLine2: UIImageView!
    
    enum NumberKeyboardType: String {
        case returnCoupon = "1"
        case checkCoupon = "2"
        case checkCouponDetail = "3"
        case gathering = "4"
        case pointExchange = "5"
    }
    
    var type: NumberKeyboardType = .returnCoupon

    enum NumberKeyboardClickType {
        case input(content: String)
        case deleteOne
        case deleteAll
        case complete(text: String)

        
        init(tag: Int, keyboardPoint: Bool = false, currentText: String) {
            if tag >= 0 && tag <= 9 {
                self = .input(content: String(describing: tag))
            } else if tag == 11 {
                if keyboardPoint {
                    self = .input(content: ".")
                } else {
                    self = .complete(text: currentText)
                }
            } else if tag == -1 {
                self = .deleteAll
            } else {
                self = .deleteOne
            }
        }
        
    }
    
    private weak var inputField: UITextField?

    private var fieldLimit = 11
    
    init(frame: CGRect, type: NumberKeyboardType = .returnCoupon) {
        super.init(frame: frame)
        self.type = type
        self.setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        self.backgroundColor = UIColor.white
        
        var titleText = "消费金额"
        
        var hasInputField = true
        
        switch self.type {
        case .returnCoupon:
            self.leftLable = self.addLabel(title: "￥", font: UIFont.systemFont(ofSize: 18))
            self.fieldLimit = 9
        case .checkCoupon:
            titleText = "券码或手机号"
            self.fieldLimit = 14
        case .checkCouponDetail:
            titleText = "手机号码"
        case .gathering:
            hasInputField = false
        case .pointExchange:
            titleText = "手机号或手机尾号查询会员"
        }
        self.titleLabel = self.addLabel(title: titleText, font: UIFont.systemFont(ofSize: 13), textColor: UIColor.cl.garyWithSameValue(99))
        
        if hasInputField {
            let inputField = UITextField()
            inputField.inputView = UIView()
            inputField.font = UIFont.systemFont(ofSize: 25)
            inputField.becomeFirstResponder()
            self.addSubview(inputField)
            self.inputField = inputField
            self.inputField?.rx.maxLength(self.fieldLimit).disposed(by: self.disposeBag)

            self.deleteBtn = self.addBtn(normalImageName: "input_delete", selectedImageName: nil, tag: -1)
            
        }
        
        self.zeroBtn = self.addBtn(normalImageName: "zero1", selectedImageName: "zero", tag: 0)
        self.oneBtn = self.addBtn(normalImageName: "one1", selectedImageName: "one", tag: 1)
        self.twoBtn = self.addBtn(normalImageName: "two1", selectedImageName: "two", tag: 2)
        self.threeBtn = self.addBtn(normalImageName: "three1", selectedImageName: "three", tag: 3)
        self.fourBtn = self.addBtn(normalImageName: "four1", selectedImageName: "four", tag: 4)
        self.fiveBtn = self.addBtn(normalImageName: "five1", selectedImageName: "five", tag: 5)
        self.sixBtn = self.addBtn(normalImageName: "six1", selectedImageName: "six", tag: 6)
        self.sevenBtn = self.addBtn(normalImageName: "seven1", selectedImageName: "seven", tag: 7)
        self.eightBtn = self.addBtn(normalImageName: "eight1", selectedImageName: "eight", tag: 8)
        self.nineBtn = self.addBtn(normalImageName: "nine1", selectedImageName: "nine", tag: 9)
        
        self.cancelBtn = self.addBtn(normalImageName: "keyboard_delete1", selectedImageName: "keyboard_delete", tag: 10)
        
        self.horiLine1 = self.addLine()
        self.horiLine2 = self.addLine()
        self.horiLine3 = self.addLine()
        self.horiLine4 = self.addLine()
        self.vertiLine1 = self.addLine()
        self.vertiLine2 = self.addLine()
        
        var nextNorImgName = "keyboard_next1"
        var nextSelImgName = "keyboard_next"

        
        switch self.type {
        case .checkCouponDetail:
            nextNorImgName = "send_coupon_keyboard"
            nextSelImgName = "send_coupon_keyboard_pressed"
        case .gathering:
            nextNorImgName = "point1"
            nextSelImgName = "point"
        default:
            nextNorImgName = "keyboard_next1"
            nextSelImgName = "keyboard_next"
        }

        self.nextBtn = self.addBtn(normalImageName: nextNorImgName, selectedImageName: nextSelImgName, tag: 11)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW: CGFloat = (self.frame.width - 1) / 3
        var btnH: CGFloat = (self.frame.height - 70 - 2) / 4

        var eX: CGFloat  = 0
        var eW: CGFloat  = 0
        
        if self.type == .gathering {
            btnH = self.frame.size.height / 4
            self.horiLine1.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.5)
            self.vertiLine1.frame = CGRect(x: self.oneBtn.frame.maxX, y: 0, width: 0.5, height: self.frame.size.height)
            self.vertiLine2.frame = CGRect(x: self.twoBtn.frame.maxX, y: 0, width: 0.5, height: self.frame.size.height)
        } else {
            
            if self.type == .returnCoupon {
                eX = 40
                eW = kScreenWidth - 40 - 37
            }
            else{
                eX = 20
                eW = kScreenWidth - 20 - 37
            }
            
            self.titleLabel?.frame = CGRect(x: 20, y: 0, width: kScreenWidth - 40, height: 20)
            self.leftLable?.frame = CGRect(x: 20, y: (self.titleLabel?.frame.maxY)!, width: 20, height: 40)
            self.inputField?.frame = CGRect(x: eX, y: (self.titleLabel?.frame.maxY)!, width: eW, height: 40)
            self.deleteBtn.frame = CGRect(x: (self.inputField?.frame.maxX)!, y: 32, width: 17, height: 17)
            
            self.horiLine1.frame = CGRect(x: 0, y: (self.inputField?.frame.maxY)! + 10, width: kScreenWidth, height: 0.5)
            self.vertiLine1.frame = CGRect(x: btnW, y: (self.inputField?.frame.maxY)! + 10, width: 0.5, height: btnH * 4 + 2)
            self.vertiLine2.frame = CGRect(x: btnW * 2, y: (self.inputField?.frame.maxY)! + 10, width: 0.5, height: btnH * 4 + 2)
        }
        

        
        
        
        self.oneBtn.frame = CGRect(x: 0, y: self.horiLine1.frame.maxY, width: btnW, height: btnH)
        self.twoBtn.frame = CGRect(x: btnW + 0.5, y: self.horiLine1.frame.maxY, width: btnW, height: btnH)
        self.threeBtn.frame = CGRect(x: btnW * 2 + 1, y: self.horiLine1.frame.maxY, width: btnW, height: btnH)
        self.fourBtn.frame = CGRect(x: 0, y: self.oneBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        self.fiveBtn.frame = CGRect(x: btnW + 0.5, y: self.oneBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        self.sixBtn.frame = CGRect(x: btnW * 2 + 1, y: self.oneBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        self.sevenBtn.frame = CGRect(x: 0, y: self.fourBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        self.eightBtn.frame = CGRect(x: btnW + 0.5, y: self.fourBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        self.nineBtn.frame = CGRect(x: btnW * 2 + 1, y: self.fourBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        self.cancelBtn.frame = CGRect(x: 0, y: self.sevenBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        self.zeroBtn.frame = CGRect(x: btnW + 0.5, y: self.sevenBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        self.nextBtn.frame = CGRect(x: btnW * 2 + 1, y: self.sevenBtn.frame.maxY + 0.5, width: btnW, height: btnH)
        
        
        self.horiLine2.frame = CGRect(x: 0, y: self.oneBtn.frame.maxY, width: kScreenWidth, height: 0.5)
        self.horiLine3.frame = CGRect(x: 0, y: self.fourBtn.frame.maxY, width: kScreenWidth, height: 0.5)
        self.horiLine4.frame = CGRect(x: 0, y: self.sevenBtn.frame.maxY, width: kScreenWidth, height: 0.5)

    }
    
    
    //MARK:- private func

    private func addLine() -> UIImageView {
        let line = UIImageView()
        line.backgroundColor = UIColor.keyboardSeparator
        self.addSubview(line)
        return line
    }
    
    private func addBtn(normalImageName: String, selectedImageName: String?, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.setBackgroundImage(UIImage(named: normalImageName), for: .normal)
        button.setBackgroundImage(UIImage(named: selectedImageName ?? ""), for: .selected)
        button.tag = tag
        
        let btnDriver = button.rx.tap.asDriver()
        

        
        btnDriver.flatMapLatest({[weak button, weak self] (_) -> Driver<NumberKeyboardClickType> in
            var text = ""
            if let field = self?.inputField {
                text = field.text ?? text
            }
            return Driver.of(NumberKeyboardClickType(tag: (button?.tag)!, keyboardPoint: (self?.type == .gathering), currentText: text))
        }).drive(onNext: {[weak self] (value) in
            self?.hadInput(type: value)
            self?.input.onNext(value)
        }).disposed(by: self.disposeBag)
        
        self.addSubview(button)
        return button
    }
    
    private func addLabel(title: String, font: UIFont, textColor: UIColor? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = font
        if let color = textColor {
            label.textColor = color
        }
        self.addSubview(label)
        return label
    }
    
    private func hadInput(type: NumberKeyboardClickType) {
        if let inputField = self.inputField {
            switch type {
            case .input(let value):
                if (inputField.text?.cl.length)! < self.fieldLimit {
                    inputField.text = (inputField.text!) + value
                }
            case .deleteOne:
                let length = inputField.text?.cl.length
                if length! > 0 {
                    inputField.text = inputField.text?.cl.substring(0, length! - 1)
                }
            case .deleteAll:
                inputField.text = nil
            case .complete(_):
                inputField.text = ""
                break
            }
        }
    }
    
}


struct NumberKeyboardError: Swift.Error {
    
    var msg: String
    
}
