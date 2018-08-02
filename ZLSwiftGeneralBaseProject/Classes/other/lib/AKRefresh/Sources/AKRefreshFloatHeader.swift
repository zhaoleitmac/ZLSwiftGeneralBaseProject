//
//  AKrefreshFloatHeader.swift
//  AKRefresh
//
//  Created by liuchang on 2016/12/2.
//  Copyright © 2016年 com.unknown. All rights reserved.
//

import UIKit

open class AKRefreshFloatHeader: AKRefreshHeader {

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (AKRefreshView.KVOPath.scrollViewContentOffsetPath.rawValue == keyPath) {
            self.frame.origin.y = (self.scrollView?.contentOffset.y ?? 0) + self.scrollViewOriginalInsets.top
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }

}
