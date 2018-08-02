//
//  PKHUD+RxBinding.swift
//  ggcms
//
//  Created by liuchang on 2017/8/10.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//
//
import Foundation
import PKHUD
import RxSwift
import RxCocoa

extension Reactive where Base : UIView {
     var activityIndicator: Binder<TaskStatus> {
        return Binder(base) { (hud, taskStatus) in
            switch taskStatus {
            case .executing:
                HUD.show(.progress, onView: self.base)
                break
            case let .executingText(desc):
                HUD.show(.labeledProgress(title:nil, subtitle:desc), onView: self.base)
                break
            case.fail(let msg):
                HUD.flash(.labeledError(title:nil, subtitle:msg), onView:self.base, delay: 1.5)
                break
            case.success:
                HUD.hide()
                break
            case let .empty(desc, _):
                HUD.flash(.label(desc), onView:self.base, delay: 1.5)
            case .notNetwork:
                HUD.flash(.label("您的手机网络好像出问题了！"), onView:self.base, delay: 1.5)
            default:
                break
            }
        }
    }
}

