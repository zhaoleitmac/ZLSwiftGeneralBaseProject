//
//  BasicVC+ZLExtension.swift
//  educationtools
//
//  Created by 赵雷 on 2019/4/23.
//  Copyright © 2019 北京红云融通技术有限公司. All rights reserved.
//

import UIKit

extension ZLExtension where Base: BasicVC {
    
    enum NavItemLocation {
        case left
        case right
    }
    
    func setNavItem(location: NavItemLocation = .right, image: UIImage?, size: CGSize, action: @escaping () -> ()) -> UIButton {
        
        let vc = self.base
        let btn = UIButton(frame: CGRect(0, 0, size.width, size.height))
        btn.setImage(image, for: .normal)
        btn.rx.tap.subscribe(onNext: { () in
            action()
        }).disposed(by: vc.disposeBag)
        if location == .right {
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        } else {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        }
        return btn
    }
    
    func setNavItem(location: NavItemLocation = .right, title: String, textColor: UIColor = UIColor.zl.fromHex("FFFFFF"), font: UIFont = UIFont.systemFont(ofSize: 16), action: @escaping () -> ()) -> UIButton {
        
        let vc = self.base
        
        let titleSize = title.zl.sizeWithFont(font: font)
        let paddingX: CGFloat = 5.0
        let paddingY: CGFloat = 5.0
        
        let btnW = titleSize.width + paddingX * 2.0
        let btnH = titleSize.height + paddingY * 2.0
        let btn = UIButton(frame: CGRect(0, 0, btnW, btnH))
        
        btn.titleLabel?.font = font
        btn.setTitleColor(textColor, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.rx.tap.subscribe(onNext: { () in
            action()
        }).disposed(by: vc.disposeBag)
        
        if location == .right {
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        } else {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        }
        return btn
    }
    
}
