//
//  LoadStatusHud+RxBinding.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/29.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

extension Reactive where Base: BasicVC {
    var loadStatus: Binder<TaskStatus> {
        return Binder(base) {(vc, taskStatus) in
            let loadHud = vc.loadHud
            switch taskStatus{
            case let .flashHUD(msg):
                HUD.flash(.label(msg))
            case .executing:
                if loadHud.reloading {
                    loadHud.show(.labeledProgressAnimation(title: ""))
                }
            case .executingText(let desc):
                loadHud.show(.labeledProgressAnimation(title: desc))
            case.fail(let msg):
                HUD.hide()
                loadHud.show(.labeledError(imageName: "response_empty", title: msg ?? " 点我重试"))
            case .failImage(let msg, let imageName):
                HUD.hide()
                loadHud.show(.labeledError(imageName: imageName, title: msg ?? " 点我重试"))
            case.success, .noMore, .successText( _), .complete:
                HUD.hide()
                loadHud.hide()
            case let .empty(desc, image):
                HUD.hide()
                loadHud.show(.labeledDataEmpty(imageName: image, title: desc))
            case .noNetwork:
                HUD.hide()
                loadHud.show(.noNetWork)
            }
        }
    }
}

extension Reactive where Base: UIView {
    var loadStatus: Binder<TaskStatus> {
        return Binder(base) {(view, taskStatus) in
            let loadHud = view.zl.loadHud
            switch taskStatus {
            case .executing:
                if loadHud.reloading {
                    loadHud.show(.labeledProgressAnimation(title: ""))
                }
            case .executingText(let desc):
                loadHud.show(.labeledProgressAnimation(title: desc))
            case .fail(let msg):
                loadHud.show(.labeledError(imageName: "response_empty", title: msg ?? " 点我重试"))
            case .failImage(let msg, let imageName):
                loadHud.show(.labeledError(imageName: imageName, title: msg ?? " 点我重试"))
                
            case.success, .noMore, .successText( _), .complete:
                loadHud.hide()
            case let .empty(desc, image):
                loadHud.show(.labeledDataEmpty(imageName: image, title: desc))
            case .noNetwork:
                loadHud.show(.noNetWork)
            default:
                break
            }
        }
    }
}

extension ZLExtension where Base: UIView {
    var loadHud: LoadStatusHud {
        get {
            var hud: LoadStatusHud?
            let loadHuds = self.base.subviews.filter { (view) -> Bool in
                return type(of: view) == LoadStatusHud.self
            }
            if loadHuds.count > 0 {
                hud = loadHuds.first as? LoadStatusHud
            } else {
                hud = LoadStatusHud.hudAddToView(self.base)
            }
            return hud!
        }
    }
}
