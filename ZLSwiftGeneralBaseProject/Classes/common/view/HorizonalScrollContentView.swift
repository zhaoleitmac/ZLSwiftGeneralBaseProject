//
//  HorizonalScrollContentView.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/22.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class HorizonalScrollContentView: UIView {

    var pageViews = [UIView]() {
        didSet {
            var count: CGFloat = 0
            for view in pageViews {
                view.frame = CGRect.init(count * kScreenWidth, 0, kScreenWidth, self.frame.height)
                self.contentScollView.addSubview(view)
                count += 1
            }
            self.contentScollView.contentSize = CGSize(width: count * kScreenWidth, height: 0)
        }
    }
    
    var pageChange: Driver<Int>! //切换到第几页

    private var currentPage: Int = 1
    
    private let disposeBag = DisposeBag()
    private weak var contentScollView: UIScrollView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let contentScollView = UIScrollView()
        contentScollView.isPagingEnabled = true
        contentScollView.bounces = false
        contentScollView.showsVerticalScrollIndicator = false
        contentScollView.showsHorizontalScrollIndicator = false
        self.addSubview(contentScollView)
        contentScollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.contentScollView = contentScollView
        self.pageChange = contentScollView.rx.contentOffset.asDriver().flatMap({[weak self] (offset) -> Driver<Int> in
            let page = Int(offset.x / kScreenWidth + 0.5) + 1
            self?.currentPage = page
            return Driver.of(page)
        })
    }
 
    public func scollPage(page: Int) {
        if currentPage != page && page > 0 {
            currentPage = page
            UIView.animate(withDuration: 0.3) {
                self.contentScollView.contentOffset = CGPoint(x: CGFloat(page - 1) * kScreenWidth, y: 0)
            }
        }
    }
}
