//
//  HorizonalScrollTitleView.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/22.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class HorizonalScrollTitleView: UIView {

    private let disposeBag = DisposeBag()
    
    static let height: CGFloat = 35
    
    private let btnMinW = kScreenWidth / 4.5
    
    var titles = [String]() {
        didSet {
            if oldValue.count > 0 {
                for button in self.buttons {
                    button.removeFromSuperview()
                }
                self.buttons.removeAll()
            }
            var btnW = kScreenWidth / CGFloat(titles.count)
            var contentSizeW: CGFloat = 0
            if titles.count > 4 {
                btnW = btnMinW
                contentSizeW = btnMinW * CGFloat(titles.count)
            }
            self.titleScollView.contentSize = CGSize(width: contentSizeW, height: 0)
            
            var count = 1
            for title in titles {
                let x: CGFloat = CGFloat(count - 1) * btnW
                let frame = CGRect(x, 0, btnW, HorizonalScrollTitleView.height)
                let titleBtn = self.addBtn(frame: frame, title: title, tag: count)
                self.buttons.append(titleBtn)
                count += 1
            }
            
            if self.buttons.count > 0 {
                self.buttons.first?.isSelected = true
                self.selectLine.frame = CGRect(0, HorizonalScrollTitleView.height - 2, btnW, 2)
            }
            
        }
    }
    
    private let btnClickedVariable = Variable(-1)

    var btnClicked: Driver<Int>! //第几个按钮被点击
    
    
    private weak var titleScollView: UIScrollView!
    
    private weak var selectLine: UIImageView!
    
    private var buttons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.btnClicked = self.btnClickedVariable.asDriver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.backgroundColor = UIColor.white
        
        let bottomLine = UIImageView()
        bottomLine.backgroundColor = UIColor.outSeparator1
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalToSuperview()
            maker.height.equalTo(1)
        }
        
        let titleScollView = UIScrollView()
        titleScollView.bounces = false
        titleScollView.showsVerticalScrollIndicator = false
        titleScollView.showsHorizontalScrollIndicator = false
        self.addSubview(titleScollView)
        titleScollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.titleScollView = titleScollView
        
        let selectLine = UIImageView()
        selectLine.backgroundColor = UIColor.appBlue
        self.titleScollView.addSubview(selectLine)
        self.selectLine = selectLine
        
    }
    
    private func addBtn(frame: CGRect, title: String, tag: Int) -> UIButton{
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.titleScollView.addSubview(button)
        button.frame = frame
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.appBlue, for: .selected)
        button.setTitleColor(UIColor.cl.garyWithSameValue(156), for: .normal)
        button.rx.tap.asDriver().drive(onNext: {[weak self, weak button] () in
            self?.handleTap(senderTag: (button?.tag)!)
        }).disposed(by: self.disposeBag)
        self.btnClicked.drive(onNext: {[weak button] (tag) in
            if tag > 0 {
                button?.isSelected = button?.tag == tag
            }
        }).disposed(by: self.disposeBag)
        return button
    }
    
    private func handleTap(senderTag: Int) {
        
        if senderTag - 1 < self.buttons.count {
            let sender = self.buttons[senderTag - 1]
            self.btnClickedVariable.value = senderTag
            
            UIView.animate(withDuration: 0.3) {
                if self.titles.count > 4 {
                    if sender.tag == self.titles.count {
                        self.titleScollView.contentOffset = CGPoint(x: sender.frame.maxX - kScreenWidth, y: 0)
                    } else if sender.tag == 1 {
                        self.titleScollView.contentOffset = CGPoint(x: 0, y: 0)
                    } else {
                        let showMax = self.titleScollView.contentOffset.x + kScreenWidth - 0.01
                        let showMin = self.titleScollView.contentOffset.x + 0.01
                        let btnW = sender.frame.width
                        if sender.frame.minX < showMin {
                            self.titleScollView.contentOffset = CGPoint(x: sender.frame.minX - btnW, y: 0)
                        }
                        if sender.frame.maxX > showMax {
                            self.titleScollView.contentOffset = CGPoint(x: sender.frame.maxX + btnW - kScreenWidth, y: 0)
                        }
                    }
                }
                self.selectLine.center.x = sender.center.x
            }
        }
    }
    
    public func tagChange(tag: Int) {
        self.handleTap(senderTag: tag)
    }
    
}
