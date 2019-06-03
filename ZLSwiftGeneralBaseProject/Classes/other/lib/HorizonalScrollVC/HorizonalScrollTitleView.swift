//
//  HorizonalScrollTitleView.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/22.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HorizonalScrollTitleView: UIScrollView {

    private let disposeBag = DisposeBag()
    
    static let height: CGFloat = 38
    
    private static let selectedFont = UIFont.boldSystemFont(ofSize: 14)
    
    private static let normalFont = UIFont.systemFont(ofSize: 14)

    private static let errorTag = -1
    
    var titles = [String]() {
        didSet {
            if oldValue.count > 0 {
                for button in self.buttons {
                    button.removeFromSuperview()
                }
                self.buttons.removeAll()
            }
            let contentCount = titles.count //> 4 ? titles.count : 4
            
            let btnWidth = kScreenWidth / CGFloat(contentCount)

            self.contentSize = CGSize(width: 0, height: 0)
            
            var count = 1
            for title in titles {
                let x: CGFloat = CGFloat(count - 1) * btnWidth
                let frame = CGRect(x, 0, btnWidth, HorizonalScrollTitleView.height)
                let titleBtn = self.addBtn(frame: frame, title: title, tag: count)
                self.buttons.append(titleBtn)
                count += 1
            }
            
            if self.buttons.count > 0 {
                let firstBtn = self.buttons.first!
                firstBtn.isSelected = true
                firstBtn.titleLabel?.font = HorizonalScrollTitleView.selectedFont
                self.selectLine.frame = CGRect(0, HorizonalScrollTitleView.height - 3, 30, 3)
                self.selectLine.center.x = firstBtn.center.x

            }
            
        }
    }
    
    private let btnClickedVariable = Variable(HorizonalScrollTitleView.errorTag)

    var btnClicked: Driver<Int>! //第几个按钮被点击
    
    
    private weak var selectLine: UIImageView!
    
    private weak var bottomLine: UIImageView!
    
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
        bottomLine.backgroundColor = UIColor.zl.garyWithSameValue(229)
        self.addSubview(bottomLine)
        self.bottomLine = bottomLine
        
        self.bounces = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        let selectLine = UIImageView()
        selectLine.backgroundColor = UIColor.zl.fromRGBA(58, 167, 255)
        self.addSubview(selectLine)
        self.selectLine = selectLine
        
    }
    
    private func addBtn(frame: CGRect, title: String, tag: Int) -> UIButton{
        let button = UIButton(type: .custom)
        button.titleLabel?.font = HorizonalScrollTitleView.normalFont
        self.addSubview(button)
        button.frame = frame
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.zl.garyWithSameValue(34), for: .selected)
        button.setTitleColor(UIColor.zl.garyWithSameValue(102), for: .normal)
        button.rx.tap.asDriver().drive(onNext: {[weak self, weak button] () in
            let tag = button?.tag ?? HorizonalScrollTitleView.errorTag
            self?.btnClickedVariable.value = tag
        }).disposed(by: self.disposeBag)
        return button
    }
    
    func changeBtn(tag: Int) {
        if tag <= self.buttons.count {
            for button in self.buttons {
                button.titleLabel?.font = button.tag == tag ? HorizonalScrollTitleView.selectedFont : HorizonalScrollTitleView.normalFont
                button.isSelected = button.tag == tag
            }
            let sender = self.buttons[tag - 1]
            
            UIView.animate(withDuration: 0.3) {
                if self.titles.count > 4 {
                    if sender.tag == self.titles.count {
                        self.contentOffset = CGPoint(x: sender.frame.maxX - kScreenWidth, y: 0)
                    } else if sender.tag == 1 {
                        self.contentOffset = CGPoint(x: 0, y: 0)
                    } else {
                        let showMax = self.contentOffset.x + kScreenWidth - 0.01
                        let showMin = self.contentOffset.x + 0.01
                        let btnW = sender.frame.width
                        if sender.frame.minX < showMin {
                            self.contentOffset = CGPoint(x: sender.frame.minX - btnW, y: 0)
                        }
                        if sender.frame.maxX > showMax {
                            self.contentOffset = CGPoint(x: sender.frame.maxX + btnW - kScreenWidth, y: 0)
                        }
                    }
                }
                self.selectLine.center.x = sender.center.x
            }
        }
    }
    
    override func layoutSubviews() {
        let height: CGFloat = 1
        self.bottomLine.frame = CGRect.init(0, self.frame.height - height, self.frame.width, height)
        super.layoutSubviews()
    }
    
}
