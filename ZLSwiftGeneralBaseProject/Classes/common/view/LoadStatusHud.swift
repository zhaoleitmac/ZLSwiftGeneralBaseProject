//
//  LoadStatusHud.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/28.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum LoadStatusHUDContentType {
    case success
    case error
    case progress
    case noNetWork
    case dataEmpty
    case labeledError(imageName: String?, title: String?)
    case labeledProgress(imageName: String?, title: String?)
    case labeledProgressAnimation(title: String?)
    case labeledDataEmpty(imageName: String?, title: String?)
}


class LoadStatusHud: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var actionBtn: UIButton!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    private var content: LoadStatusHUDContentType = .success
    
    var reloading = false
    
    var action: (() -> ())?
    
    class func hudAddToView(_ view: UIView) -> LoadStatusHud {
        let hud = LoadStatusHud.zl.fromXIB()
        view.addSubview(hud)
        hud.snp.makeConstraints({ (maker) in
            maker.width.equalTo(kScreenWidth)
            maker.top.left.bottom.equalToSuperview()
        })
        hud.show(.success)
        return hud
    }
    
    func show(_ content: LoadStatusHUDContentType) {
        if self.superview != nil {
            self.reloading = false
            self.content = content
            self.isHidden = false
            self.actionBtn.isUserInteractionEnabled = false
            self.indicatorView.isHidden = true
            switch content {
            case .success:
                self.isHidden = true
            case .error:
                self.actionBtn.isUserInteractionEnabled = true
                self.changeContent(imageName: "response_empty", title: "加载失败，点击重试")
            case let .labeledError(imageName, title):
                self.actionBtn.isUserInteractionEnabled = true
                self.changeContent(imageName: imageName, title: title)
            case .progress:
                self.changeContent(imageName: nil, title: "努力加载中...")
            case let .labeledProgress(imageName, title):
                self.changeContent(imageName: imageName, title: title)
            case let .labeledProgressAnimation(title):
                self.indicatorView.isHidden = false
                self.changeContent(imageName: nil, title: title)
                self.indicatorView.startAnimating()
            case .dataEmpty:
                self.changeContent(imageName: "response_empty", title: "暂无数据")
            case let .labeledDataEmpty(imageName, title):
                self.changeContent(imageName: imageName ?? "response_empty", title: title ?? "暂无数据")
            case .noNetWork:
                self.changeContent(imageName: "not_net", title: "您的手机网络好像出问题了，请检查您的网络设置")
            }
        }
        
    }
    
    func hide() {
        self.show(.success)
    }
    
    private func changeContent(imageName: String?, title: String? = nil) {
        if let imageName = imageName {
            self.imageView.image = UIImage(named: imageName)
            self.imageView.isHidden = false
        } else {
            self.imageView.isHidden = true
        }
        if let title = title {
            self.actionBtn.setTitle(title, for: .normal)
            self.actionBtn.isHidden = false
        } else {
            self.actionBtn.isHidden = true
        }
    }
    
    @IBAction private func btnAction() {
        self.reloading = true
        if let action = self.action {
            action()
        }
    }
    
}
