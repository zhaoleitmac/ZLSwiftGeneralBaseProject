//
//  BasicCellModel.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/11.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

class BasicCellModel: NSObject {

    var contentSize = CGSize(width: 0, height: 0)
    
    var cellHeight: CGFloat {
        get {
            return contentSize.height
        }
    }
    
    var cellWidth: CGFloat {
        get {
            return contentSize.width
        }
    }
    
    init(contentWidth: CGFloat = kScreenWidth) {
        super.init()
        self.contentSize = CGSize(width: contentWidth, height: 0)
    }
    
}
