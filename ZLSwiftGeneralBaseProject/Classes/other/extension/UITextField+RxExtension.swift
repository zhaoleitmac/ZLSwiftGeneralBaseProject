//
//  UITextField+RxExtension.swift
//  ZHDJ
//
//  Created by 刘昶 on 2017/4/15.
//  Copyright © 2017年 com.akira. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base : UITextField {
    func maxLength(_ maxLength:Int) -> Disposable{
        let textFiled = self.base
        let c = self.controlEvent(.editingChanged).subscribe(onNext: {[weak textFiled] () in
            // 获取非选中状态文字范围
            let selectedRange = textFiled?.markedTextRange
            // 没有非选中文字，截取多出的文字
            if selectedRange == nil {
                let text = textFiled?.text ?? ""
                if text.count > maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    textFiled?.text = String(text[..<index])
                }
            }
        })
        return c
    }
    
    func validate(maxLength:Int? = nil,regex:String? = nil) -> Disposable {
       let b = self.text.orEmpty
        .scan("") { (old, new)  in
            
            var revert = false
            revert = (self.base.markedTextRange == nil) && (new.count > maxLength ?? Int.max)
            if !revert,let re = regex,re.count > 0 {
                let reg = NSPredicate(format: "SELF MATCHES %@", re)
                revert = !reg.evaluate(with: new)
            }
            return revert ? old : new
        }
        .asDriver(onErrorJustReturn: "")
        .drive(onNext: {(text) in
            self.base.text = text
        })
        
        return b
    }
    
    
}

extension Reactive where Base : UITextView {
    
    func maxLength(_ maxLength:Int) -> Disposable{
        let textView = self.base
        let c = self.didChange.subscribe(onNext: {[weak textView] () in
            // 获取非选中状态文字范围
            let selectedRange = textView?.markedTextRange
            // 没有非选中文字，截取多出的文字
            if selectedRange == nil {
                let text = textView?.text ?? ""
                if text.count > maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    textView?.text = String(text[..<index])
                }
            }
        })
        return c
    }
    
    func validate(maxLength:Int? = nil,regex:String? = nil) -> Disposable {
        let b = self.text.orEmpty
            .scan("") { (old, new)  in
                
                var revert = false
                revert = (self.base.markedTextRange == nil) && (new.count > maxLength ?? Int.max)
                if !revert,let re = regex,re.count > 0 {
                    let reg = NSPredicate(format: "SELF MATCHES %@", re)
                    revert = !reg.evaluate(with: new)
                }
                return revert ? old : new
            }
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: {(text) in
                self.base.text = text
            })
        
        return b
        
    }
}

//MARK:- textField
extension ZLExtension where Base: UITextField {
    
    func setLeftImageView(imageName: String,extraWidth: CGFloat) {
        var leftView = UIImageView(image: UIImage(named: imageName))
        leftView.contentMode = .center
        leftView.zl.width += extraWidth
        self.base.leftView = leftView
        self.base.leftViewMode = .always
    }
}
