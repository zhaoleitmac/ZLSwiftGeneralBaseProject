//
//  CommonNavigationVC+ZLExtension.swift
//  YFCB-test
//
//  Created by 赵雷 on 2018/10/25.
//  Copyright © 2018 缀新网络技术有限公司. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension ZLExtension where Base == CommonNavigationVC {
    var isHidden: Bool {
        set {
            if newValue {
                self.base.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.base.navigationBar.shadowImage = UIImage()
            } else {
                self.base.navigationBar.setBackgroundImage(UIImage.zl.fromColor(UIColor.naviBarBG, CGSize(width: 1, height: 64)), for: .default)
                self.base.navigationBar.shadowImage = nil
            }
        }
        get {
            return self.base.navigationBar.shadowImage != nil
        }
    }
}
