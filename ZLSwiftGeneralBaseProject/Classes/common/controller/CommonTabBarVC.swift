//
//  CommonTabBarVC.swift
//  ZHDJ
//
//  Created by liuchang on 2017/4/12.
//  Copyright © 2017年 com.akira. All rights reserved.
//

import UIKit

class CommonTabBarVC: UITabBarController {
    static var setupTabBarItemStyle:()->() = {
        let barItem = UITabBarItem.appearance()
//        let normalAttr = [NSFontAttributeName:UIFont.systemFont(ofSize: 0),NSForegroundColorAttributeName :UIColor.clear]
//        barItem.setTitleTextAttributes(normalAttr, for: .normal)
        
        
        return {}
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = type(of: self).setupTabBarItemStyle
        self.tabBar.backgroundImage = UIImage.zl.fromColor(UIColor.white, CGSize(width: 5, height: 5))
    }
    
    func appendChildVC(_ vc:UIViewController,barTitle:String,normalBarImage:UIImage,selectedBarImage:UIImage){
        let normalImage = normalBarImage.withRenderingMode(.alwaysOriginal)
        let selectedImage = selectedBarImage.withRenderingMode(.alwaysOriginal)
        let barItem = UITabBarItem(title: barTitle, image:normalImage,selectedImage:selectedImage)
//        barItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        UITabBarItem.appearance()
        vc.tabBarItem = barItem
        
        
        self.addChild(vc)
        
    }

   

}
