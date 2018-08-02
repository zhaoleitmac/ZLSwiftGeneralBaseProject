//
// Created by liuchang on 2017/4/14.
// Copyright (c) 2017 com.akira. All rights reserved.
//

import UIKit

extension CLExtension where Base: UITableView {
    func setEmptyHeader(_ height: CGFloat = 0.01,
                        color: UIColor? = nil) {
        let header = self.createEmptyView(height, color: color)
        base.tableHeaderView = header
    }

    func setEmptyFooter(_ height: CGFloat = 0.01,
                        color: UIColor? = nil) {
        let footer = self.createEmptyView(height, color: color)
        base.tableFooterView = footer
    }

    func setEmptyHeaderAndFooter(headerHeight: CGFloat = 0.01,
                                 footerHeight: CGFloat = 0.01,
                                 headerColor: UIColor? = nil,
                                 footerColor: UIColor? = nil) {
        setEmptyHeader(headerHeight, color: headerColor)
        setEmptyFooter(footerHeight, color: footerColor)
    }

    private func createEmptyView(_ height: CGFloat,
                                 color: UIColor? = nil) -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        if let bgColor = color {
            header.backgroundColor = bgColor
        }
        return header
    }

}
