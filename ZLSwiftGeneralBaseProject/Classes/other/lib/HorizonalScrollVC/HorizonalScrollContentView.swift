//
//  HorizonalScrollContentView.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/22.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HorizonalScrollContentView: UIScrollView {

    var pageViews = [UIView]() {
        didSet {
            var count: CGFloat = 0
            for view in pageViews {
                view.frame = CGRect(count * kScreenWidth, 0, kScreenWidth, self.frame.height)
                view.autoresizingMask = AutoresizingMask.flexibleHeight
                self.addSubview(view)
                count += 1
            }
            self.contentSize = CGSize(width: count * kScreenWidth, height: 0)
        }
    }
    
    var pageChange: Driver<Int>! //切换到第几页

    private var currentPage: Int = 1
    
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.isPagingEnabled = true
        self.bounces = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        self.pageChange = self.rx.contentOffset.asDriver().flatMap({[weak self] (offset) -> Driver<Int> in
            let page = Int(offset.x / kScreenWidth + 0.5) + 1
            self?.currentPage = page
            return Driver.of(page)
        })
    }
 
    public func scollPage(page: Int, animation: Bool = true) {
        if self.currentPage != page && page > 0 {
            self.currentPage = page
            if animation {
                UIView.animate(withDuration: 0.3) {
                    self.contentOffset = CGPoint(x: CGFloat(page - 1) * kScreenWidth, y: 0)
                }
            } else {
                self.contentOffset = CGPoint(x: CGFloat(page - 1) * kScreenWidth, y: 0)

            }
        }
    }
    
    public func resetContentOffset() {
        let x = CGFloat(self.currentPage - 1) * kScreenWidth
        if x <= self.contentSize.width {
            self.contentOffset = CGPoint(x: x, y: 0)

        }
    }
}
