//
//  FlexibleButton.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/30.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

enum FlexibleButtonType {
    
    case topBottom(space: CGFloat?, imageSize: CGSize?, fontSize: CGFloat)
    case leftRight(space: CGFloat?, imageSize: CGSize?, fontSize: CGFloat)
    case bottomTop(space: CGFloat?, imageSize: CGSize?, fontSize: CGFloat)
    case rightLeft(space: CGFloat?, imageSize: CGSize?, fontSize: CGFloat)
    
    private func loctionInfo() -> (space: CGFloat?, imageSize: CGSize?, fontSize: CGFloat) {
        switch self {
        case let .topBottom(space, imageSize, fontSize):
            return (space: space, imageSize: imageSize, fontSize: fontSize)
        case let .leftRight(space, imageSize, fontSize):
            return (space: space, imageSize: imageSize, fontSize: fontSize)
        case let .bottomTop(space, imageSize, fontSize):
            return (space: space, imageSize: imageSize, fontSize: fontSize)
        case let .rightLeft(space, imageSize, fontSize):
            return (space: space, imageSize: imageSize, fontSize: fontSize)
        }
    }
    
    var space: CGFloat? {
        return self.loctionInfo().space
    }
    
    var imageSize: CGSize? {
        return self.loctionInfo().imageSize
    }

    var fontSize: CGFloat {
        return self.loctionInfo().fontSize
    }
}

class FlexibleButton: UIButton {

    private var space: CGFloat = 5
    
    private var imageW: CGFloat = 50

    private var imageH: CGFloat = 50

    private var fontSize: CGFloat = 18
    
    private var type: FlexibleButtonType = .leftRight(space: nil, imageSize: nil, fontSize: 18) {
        didSet {
            self.space = self.type.space ?? self.space
            self.imageW = self.type.imageSize?.width ?? self.imageW
            self.imageH = self.type.imageSize?.height ?? self.imageW
            self.fontSize = self.type.fontSize
            self.titleLabel?.font = UIFont.systemFont(ofSize: self.fontSize)
        }
    }
    
    init(frame: CGRect, type: FlexibleButtonType) {
        super.init(frame: frame)
        self.type = type
        self.space = self.type.space ?? self.space
        self.imageW = self.type.imageSize?.width ?? self.imageW
        self.imageH = self.type.imageSize?.height ?? self.imageW
        self.fontSize = self.type.fontSize
        self.titleLabel?.font = UIFont.systemFont(ofSize: self.fontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let font = UIFont.systemFont(ofSize: self.fontSize)
        let title = self.currentTitle ?? ""
        let titleSize = title.zl.sizeWithFont(font: font)
        
        let contentW = titleSize.width + self.imageW + self.space
        let contentH = titleSize.height + self.imageH + self.space
        let W = contentRect.width
        let H = contentRect.height
        
        let horiBlank = (W - contentW) * 0.5
        let vertiBlank = (H - contentH) * 0.5
        
        let x = (W - self.imageW) * 0.5
        let y = (H - self.imageH) * 0.5

        var imageRect = contentRect
        
        switch self.type {
        case .topBottom(_, _, _):
            let actualY = vertiBlank > 0 ? vertiBlank : 0
            imageRect = CGRect(x, actualY, self.imageW, self.imageH)
        case .leftRight(_, _, _):
            let actualX = horiBlank > 0 ? horiBlank : 0
            imageRect = CGRect(actualX, y, self.imageW, self.imageH)
        case .bottomTop(_, _, _):
            let actualY = H - (vertiBlank > 0 ? vertiBlank : 0) - self.imageH
            imageRect = CGRect(x, actualY, self.imageW, self.imageH)
        case .rightLeft(_, _, _):
            let actualX = W - (horiBlank > 0 ? horiBlank : 0) - self.imageW
            imageRect = CGRect(actualX, y, self.imageW, self.imageH)
        }
        return imageRect
        
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let font = UIFont.systemFont(ofSize: self.fontSize)
        let title = self.currentTitle ?? ""
        let titleSize = title.zl.sizeWithFont(font: font)

        let contentW = titleSize.width + self.imageW + self.space
        let contentH = titleSize.height + self.imageH + self.space
        
        let W = self.frame.width
        let H = self.frame.height
        
        let horiBlank = (W - contentW) * 0.5
        let vertiBlank = (H - contentH) * 0.5
        
        let x = (W - titleSize.width) * 0.5
        let y = (H - titleSize.height) * 0.5
        
        var titleRect = contentRect
        
        let width = titleSize.width > contentRect.width ? contentRect.width : titleSize.width
        
        switch self.type {
        case .topBottom(_, _, _):
            let actualY = H - (vertiBlank > 0 ? vertiBlank : 0) - titleSize.height
            titleRect = CGRect(x, actualY, width, titleSize.height)
        case .leftRight(_, _, _):
            let actualX = W - (horiBlank > 0 ? horiBlank : 0) - titleSize.width
            titleRect = CGRect(actualX, y, width, titleSize.height)
        case .bottomTop(_, _, _):
            let actualY = vertiBlank > 0 ? vertiBlank : 0
            titleRect = CGRect(x, actualY, width, titleSize.height)
        case .rightLeft(_, _, _):
            let actualX = horiBlank > 0 ? horiBlank : 0
            titleRect = CGRect(actualX, y, width, titleSize.height)
        }
        return titleRect
    }
    
    
}
