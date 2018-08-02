//
//  BasicVC.swift
//  ggcms
//
//  Created by liuchang on 2017/7/27.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class BasicVC: UIViewController {
    
    var navigationEdgePanEnable = true
    
    let disposeBag = DisposeBag()
    
    lazy var loaddingHud: LoadStatusHud = {
        let loaddingHud = LoadStatusHud.hudAddToView(self.view)
        loaddingHud.snp.makeConstraints({ (maker) in
            maker.width.equalTo(kScreenWidth)
            maker.top.left.bottom.equalToSuperview()
        })
        loaddingHud.actionDriver.drive(onNext: {[weak self] () in
            self?.hudActionForLoadData()
        }).disposed(by: self.disposeBag)
        return loaddingHud
    }()
        
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: - VC LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = self.view.backgroundColor else {
            self.view.backgroundColor = UIColor.white
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = self.navigationEdgePanEnable
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - VC initial
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        let className = NSStringFromClass(type(of: self)).components(separatedBy: ".").last
        var xibName = nibNameOrNil
        if let _ = Bundle.main.path(forResource: className, ofType: "nib"),
            let version = Float(UIDevice.current.systemVersion),version < 9{
            xibName = className
        }

        super.init(nibName: xibName, bundle: nil)
    }

    //重新加载数据，loaddingHud默认调这个方法，子类需重写
    
    func hudActionForLoadData() {}
    
    func isInTabBarVC() -> Bool {
        let inTabBarVC = navigationController?.parent?.isKind(of: UITabBarController.self)
        return inTabBarVC != nil && inTabBarVC!
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        Logger.debug("\(type(of: self)) <\(self)> memory safe")
    }

}


