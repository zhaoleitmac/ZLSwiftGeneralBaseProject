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
    case dataEmpty(imageName: String?, title: String?)
    case noNetWork
    
    case labeledError(imageName: String?, title: String?, subtitle: String?, btnTitle: String?)
    case labeledProgress(imageName: String?, title: String?, subtitle: String?)
    case labeledProgressAnimation(imageArray: [String], title: String?, subtitle: String?)
    case labeledDataEmpty(imageName: String?, title: String?, subtitle: String?, btnTitle: String?)
}


class LoadStatusHud: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var subLabel: UILabel!
    @IBOutlet private weak var actionBtn: UIButton!
    
    var actionDriver: Driver<Void>!
    
    private weak var superView: UIView?
    
    class func hudAddToView(_ view: UIView) -> LoadStatusHud {
        let hud = LoadStatusHud.cl.formXIB()
        hud.actionDriver = hud.actionBtn.rx.tap.asDriver()
        view.addSubview(hud)
        hud.superView = view
        hud.show(.success)
        return hud
    }
    
    func show(_ content: LoadStatusHUDContentType) {
        if self.superView != nil {
            self.isHidden = false
            switch content {
            case .success:
                self.isHidden = true
            case .error:
                self.changeContent(imageName: "bg_erro", title: "哎呀...出错了", btnTitle: "点我重试")
            case let .labeledError(imageName, title, subtitle, btnTitle):
                self.changeContent(imageName: imageName, title: title, subtitle: subtitle, btnTitle: btnTitle)
            case .progress:
                self.changeContent(imageName: nil, title: "努力加载中...")
            case let .labeledProgress(imageName, title, subtitle):
                self.changeContent(imageName: imageName, title: title, subtitle: subtitle)
            case let .labeledProgressAnimation(imageArray, title, subtitle):
                let image = imageArray.count > 0 ? imageArray.first : nil
                self.changeContent(imageName: image, title: title, subtitle: subtitle)
                if imageArray.count > 1 {
                    self.imageViewStartAnimation(imageArray: imageArray)
                }
            case let .dataEmpty(imageName, title):
                self.changeContent(imageName: imageName ?? "no_data_img", title: title ?? "暂无数据")
            case let .labeledDataEmpty(imageName, title, subtitle, btnTitle):
                self.changeContent(imageName: imageName, title: title, subtitle: subtitle, btnTitle: btnTitle)
            case .noNetWork:
                self.changeContent(imageName: "not_net", title: "您的手机网络好像出问题了！", subtitle: "请检查您的网络设置", btnTitle: "刷新一下")
            }
        }
        
    }
    
    func hide() {
        self.show(.success)
    }
    
    private func changeContent(imageName: String?, title: String?, subtitle: String? = nil, btnTitle: String? = nil) {
        self.imageView.stopAnimating()
        imageName != nil ? (self.imageView.image = UIImage(named: imageName!)) : (self.imageView.isHidden = true)
        title != nil ? (self.mainLabel.text = title!) : (self.mainLabel.isHidden = true)
        subtitle != nil ? (self.subLabel.text = subtitle!) : (self.subLabel.isHidden = true)
        btnTitle != nil ? (self.actionBtn.setTitle(btnTitle, for: .normal)) : (self.actionBtn.isHidden = true)
    }
    
    private func imageViewStartAnimation(imageArray: [String]) {
        self.imageView.animationImages = imageArray.map({UIImage(named: $0)!})
        self.imageView.animationDuration = 0.25
        self.imageView.startAnimating()
    }
    
}
