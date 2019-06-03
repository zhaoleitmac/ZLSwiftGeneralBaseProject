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

extension Reactive where Base: UIView {
    var activityIndicator: Binder<TaskStatus> {
        return Binder(base) { (hud, taskStatus) in
            HUD.hide()
            switch taskStatus {
            case let .flashHUD(msg):
                HUD.flash(.label(msg))
            case .executing:
                HUD.show(.progress)
                break
            case let .executingText(desc):
                HUD.show(.labeledProgress(title:nil, subtitle:desc), onView: self.base)
                break
            case.fail(let msg):
                HUD.flash(.label(msg ?? "访问失败，请稍后再试"))
                break
            case.success, .complete:
                HUD.hide()
                break
            case.successText(let desc):
                HUD.flash(.label(desc))
                break
            case let .empty(desc, _):
                HUD.flash(.label(desc ?? "数据为空"))
            case .noNetwork:
                HUD.flash(.label("您的手机网络好像出问题了！"))
            default:
                break
            }
        }
    }
}


