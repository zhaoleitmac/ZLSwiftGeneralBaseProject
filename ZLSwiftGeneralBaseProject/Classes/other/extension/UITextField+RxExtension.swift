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
extension Reactive where Base : UITextField{
    func maxLength(_ maxLength:Int) -> Disposable{
        return self.validate(maxLength: maxLength)
    }
    func validate(maxLength:Int? = nil,regex:String? = nil) -> Disposable {
       let b = self.text.orEmpty
        .scan("") { (old, new)  in
            
            var revert = false
            revert = (self.base.markedTextRange == nil) && (new.characters.count > maxLength ?? Int.max)
            if !revert,let re = regex,re.characters.count > 0 {
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

