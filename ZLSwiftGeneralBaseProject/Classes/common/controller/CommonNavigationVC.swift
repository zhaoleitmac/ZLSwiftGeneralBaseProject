//
//  CommonNavigationVC.swift
//  ZHDJ
//
//  Created by liuchang on 2017/4/12.
//  Copyright © 2017年 com.akira. All rights reserved.
//

import UIKit

class CommonNavigationVC: UINavigationController {
    static var setupNavigationBarStyle:()->Void = {
        //load intinal dispach_once被废弃，利用延迟加载，变相只执行一次，
        let bar =  UINavigationBar.appearance()
        let barItem = UIBarButtonItem.appearance()
        let bgImage = UIImage.cl.formColor(UIColor.naviBarBG, CGSize(width: 1, height: 1))
        let titleShadow = NSShadow()
        let titleTextAttr = [NSAttributedStringKey.shadow: titleShadow,
                             NSAttributedStringKey.font: UIFont.naviBarTitleFont,
                             NSAttributedStringKey.foregroundColor: UIColor.white]
        let itemTextAttrNormal = [NSAttributedStringKey.shadow: titleShadow,
                                  NSAttributedStringKey.font: UIFont.naviBarItemFont,
                                  NSAttributedStringKey.foregroundColor: UIColor.naviBarTitle]
        let itemTextAttrHighlight = [NSAttributedStringKey.shadow:titleShadow,
                                     NSAttributedStringKey.font:UIFont.naviBarItemFont,
                                     NSAttributedStringKey.foregroundColor:UIColor.naviBarItems]
        
        bar.tintColor = UIColor.white;
        bar.setBackgroundImage(bgImage, for: .default)
        bar.titleTextAttributes = titleTextAttr
        
        barItem.tintColor = UIColor.white
        barItem.setTitleTextAttributes(itemTextAttrNormal, for: .normal)
        barItem.setTitleTextAttributes(itemTextAttrHighlight, for: .highlighted)
        
        return {}
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = CommonNavigationVC.setupNavigationBarStyle
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let isRoot = self.childViewControllers.count == 0
        if (!isRoot){
            let target:UIViewController
            let selector = #selector(back)
            if viewController.responds(to: selector) {
                target = viewController
            }else{
                target = self
            }
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bar_back_0"), style: .plain, target: target, action: selector)
        }
        
        viewController.hidesBottomBarWhenPushed = !isRoot
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func back() {
        self.popViewController(animated: true)
    }
    
    open class func currentNavigationController() -> UINavigationController {
        let appDelegage = UIApplication.shared.delegate;
        let rootVC = appDelegage?.window??.rootViewController;
        var nv = UINavigationController() ;
        
        if rootVC is UITabBarController {
            let tabVC: UITabBarController = rootVC as! UITabBarController;
            if tabVC.selectedViewController is UINavigationController {
                nv = (tabVC.selectedViewController as! UINavigationController?)!;
            }
        } else if rootVC is UINavigationController{
            nv = (rootVC as! UINavigationController?)!;
        }
        return nv;
    }

}
