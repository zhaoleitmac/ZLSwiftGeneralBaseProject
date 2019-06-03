//
//  UIButton+ZLExtension.swift
//  YFCB
//
//  Created by 赵雷 on 2018/11/15.
//  Copyright © 2018 缀新网络技术有限公司. All rights reserved.
//

import UIKit

extension ZLExtension where Base: UIButton {

    func setImage(videoUrl: String?,
                  for state: UIControl.State,
                  placeholder: UIImage? = nil) {
        let button = self.base
        button.setImage(placeholder, for: state)
        if let videoUrl = videoUrl, let url = URL(string: videoUrl) {
            DispatchQueue.global().async {
                if let image = Base.zl.getImage(videoUrl: url) {
                    DispatchQueue.main.async {
                        button.setImage(image, for: state)
                    }
                }
            }
        }
    }

    func setBackgroundImage(videoUrl: String?,
                  for state: UIControl.State,
                  placeholder: UIImage? = nil) {
        let button = self.base
        button.setBackgroundImage(placeholder, for: state)
        if let videoUrl = videoUrl, let url = URL(string: videoUrl) {
            DispatchQueue.global().async {
                if let image = Base.zl.getImage(videoUrl: url) {
                    DispatchQueue.main.async {
                        button.setBackgroundImage(image, for: state)
                    }
                }
            }
        }
    }
    
}

private var NormalBgImageColorKey = "NormalBgImageColorKey"

private var HighLightedBgImageColorKey = "HighLightedBgImageColorKey"

private var SelectedBgImageColorKey = "SelectedBgImageColorKey"

private var DisabledBgImageColorKey = "DisableBgImageColorKey"


extension UIButton {

    @IBInspectable var normalBgImageColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &NormalBgImageColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let color = newValue {
                let image = UIImage.zl.fromColor(color, CGSize(1, 1))
                self.setBackgroundImage(image, for: .normal)
            } else {
                self.setBackgroundImage(nil, for: .normal)
            }
        }
        get{
            let normalBgImageColor = objc_getAssociatedObject(self,&NormalBgImageColorKey) as? UIColor
            return normalBgImageColor!
        }
    }
    
    @IBInspectable var highlightedBgImageColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &HighLightedBgImageColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let color = newValue {
                let image = UIImage.zl.fromColor(color, CGSize(1, 1))
                self.setBackgroundImage(image, for: .highlighted)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
            }
        }
        get{
            let disabledBgImageColor = objc_getAssociatedObject(self,&HighLightedBgImageColorKey) as? UIColor
            return disabledBgImageColor!
        }
    }
    
    @IBInspectable var selectedBgImageColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &SelectedBgImageColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let color = newValue {
                let image = UIImage.zl.fromColor(color, CGSize(1, 1))
                self.setBackgroundImage(image, for: .selected)
            } else {
                self.setBackgroundImage(nil, for: .selected)
            }
        }
        get{
            let disabledBgImageColor = objc_getAssociatedObject(self,&SelectedBgImageColorKey) as? UIColor
            return disabledBgImageColor!
        }
    }
    
    @IBInspectable var disabledBgImageColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &DisabledBgImageColorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let color = newValue {
                let image = UIImage.zl.fromColor(color, CGSize(1, 1))
                self.setBackgroundImage(image, for: .disabled)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
            }
        }
        get{
            let disabledBgImageColor = objc_getAssociatedObject(self,&DisabledBgImageColorKey) as? UIColor
            return disabledBgImageColor!
        }
    }
    
}
