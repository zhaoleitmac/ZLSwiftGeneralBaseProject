//
//  UIImage+RxExtension.swift
//  ggcms
//
//  Created by liuchang on 2017/8/16.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base:UIImage{
    func jpgZip(maxLength:Int) -> Observable<Data?>{
        return Observable.create { (observer) -> Disposable in
            self.base.cl.jpgData(maxLength: maxLength, complate: { (data) in
                observer.onNext(data)
            })
            return Disposables.create()
        }
    }
}
