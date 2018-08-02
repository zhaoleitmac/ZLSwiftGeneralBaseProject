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

extension Reactive where Base: BasicVC {
    var loaddingStatus: Binder<TaskStatus> {
        let vc = self.base
        return Binder(base) {[unowned vc] (hud, taskStatus) in
            switch taskStatus{
            case .executing:
                vc.loaddingHud.show(.progress)
            case .executingText(let desc):
                vc.loaddingHud.show(.labeledProgress(imageName: nil, title: desc, subtitle: nil))
            case.fail(let msg):
                vc.loaddingHud.show(.labeledError(imageName: nil, title: msg, subtitle: nil, btnTitle: "点我重试"))
            case.success:
                vc.loaddingHud.hide()
            case let .empty(desc, image):
                vc.loaddingHud.show(.dataEmpty(imageName: (image ?? "no_data_img"), title: desc))
            case .notNetwork:
                vc.loaddingHud.show(.noNetWork)
            default:
                break
            }
        }
    }
    
}
