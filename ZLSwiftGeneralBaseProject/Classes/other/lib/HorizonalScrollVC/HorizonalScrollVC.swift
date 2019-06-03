//
//  HorizonalScrollVC.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/22.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import SnapKit

class HorizonalScrollVC: BasicVC {

    var models: [HorizonalScrollChildVCModel] = [] {
        didSet {
            if self.subViewDidLoad {
                self.setupData()
            } else {
                self.subViewDidLoad = true
            }
        }
    }
    //当只有一个子控制器是否显示按钮栏
    var showTitleWhenSingle = false
    
    weak var titleScollView: HorizonalScrollTitleView!
    
    private weak var contentScollView: HorizonalScrollContentView!
    
    private var subViewDidLoad = false
    
    var isScrollEnabled = true {
        didSet {
            if let contentScollView = self.contentScollView {
                contentScollView.isScrollEnabled = isScrollEnabled
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        if self.models.count > 0 {
            self.setupData()
        } else {
            self.subViewDidLoad = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let recognizer = navigationController?.interactivePopGestureRecognizer {
            contentScollView.panGestureRecognizer.require(toFail: recognizer)
        }
        if let contentScollView = self.contentScollView {
            contentScollView.resetContentOffset()
        }
    }
    
    private func setupView() {
        let titleScollView = HorizonalScrollTitleView()
        titleScollView.isHidden = true
        self.view.addSubview(titleScollView)
        titleScollView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(HorizonalScrollTitleView.height)
        }
        self.titleScollView = titleScollView
        
        let contentScollView = HorizonalScrollContentView()
        contentScollView.isScrollEnabled = isScrollEnabled
        contentScollView.isHidden = true
        self.view.addSubview(contentScollView)
        contentScollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleScollView.snp.bottom)
            maker.left.bottom.right.equalToSuperview()
        }
        self.contentScollView = contentScollView
        
        titleScollView.btnClicked.asDriver(onErrorJustReturn: -1).drive(onNext: {[weak self] (tag) in
            if let this = self {
                this.contentScollView.scollPage(page: tag)
            }
            
        }).disposed(by: self.disposeBag)
        
        contentScollView.pageChange.drive(onNext: {[weak self] (page) in
            if let this = self {
                this.titleScollView.changeBtn(tag: page)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    if page >= 1, this.models.count > page - 1 {
                        this.models[page - 1].dataSource.scrollToAppear()
                    }
                }
                
            }
        }).disposed(by: self.disposeBag)
        
    }

    private func setupData() {
        if self.models.count > 0 {
            self.titleScollView.isHidden = false
            self.contentScollView.isHidden = false
            let titles = models.map {$0.title}
            self.titleScollView.titles = titles
            for vc in self.children {
                vc.removeFromParent()
                vc.view.removeFromSuperview()
            }
            let pageViews = models.map { (model) -> UIView in
                let vc = model.childVC
                self.addChild(vc)
                return model.childVC.view
            }
            self.contentScollView.pageViews = pageViews
            if !showTitleWhenSingle {
                if self.models.count == 1 {
                    self.titleScollView.isHidden = true
                    self.contentScollView.snp.remakeConstraints({ (maker) in
                        maker.edges.equalToSuperview()
                    })
                } else {
                    self.titleScollView.isHidden = false
                    self.contentScollView.snp.remakeConstraints { (maker) in
                        maker.top.equalTo(titleScollView.snp.bottom)
                        maker.left.bottom.right.equalToSuperview()
                    }
                }
            }
            _ = self.models[0].dataSource.scrollToAppear()
        } else {
            self.titleScollView.isHidden = true
            self.contentScollView.isHidden = true
        }
    }
    
    func switchPage(to index: Int, animation: Bool = true) {
        self.contentScollView.scollPage(page: index, animation: animation)
    }
    
}

protocol HorizonalScrollChildDataSouce {
    
    func scrollToAppear()
    
}


struct HorizonalScrollChildVCModel {
    var childVC: UIViewController
    var title: String
    var dataSource: HorizonalScrollChildDataSouce
}


