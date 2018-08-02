//
//  AKRefresh.swift
//  AKRefresh
//
//  Created by liuchang on 2016/11/30.
//  Copyright © 2016年 com.unknown. All rights reserved.
//

import UIKit
private var AKRefreshBaseKey = "AKRefreshBaseKey"
public class AKRefresh<Base>{
    public var base:Base{
        get{
            let o = objc_getAssociatedObject(self, &AKRefreshBaseKey)
            return o as! Base
        }
    }
    init(_ base:Base) {
        objc_setAssociatedObject(self, &AKRefreshBaseKey, base, .OBJC_ASSOCIATION_RETAIN)
    }
}

public protocol AKRefreshCompatible{
    associatedtype AKRefreshCompatibleType
    var akr:AKRefresh<AKRefreshCompatibleType>{get}
}

private var AKRefreshAssociatedKey = "AKRefresh"

extension AKRefreshCompatible {
    public var akr:AKRefresh<Self>{
        get{
            var instance = objc_getAssociatedObject(self,&AKRefreshAssociatedKey) as? AKRefresh<Self>
            if instance != nil{
                return instance!
            }else{
                instance = AKRefresh(self)
                objc_setAssociatedObject(self, &AKRefreshAssociatedKey, instance!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return instance!
            }

        }

    }

}

private var AKRefreshHeaderAssociatedKey:UInt8 = 2
private var AKRefreshFooterAssociatedKey:UInt8 = 3
extension AKRefresh where Base:UIScrollView{
     
    public var header:AKRefreshHeader?{
        get{
            return objc_getAssociatedObject(self.base, &AKRefreshHeaderAssociatedKey) as? AKRefreshHeader
        }
        set {
            if let oldHeader = header{
                oldHeader.removeFromSuperview()
            }
            if let header = newValue {
                self.base.insertSubview(header, at: 0)
            }
            objc_setAssociatedObject(self.base, &AKRefreshHeaderAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)

        }
    }
    public var footer:AKRefreshFooter?{

        get{
            return objc_getAssociatedObject(self, &AKRefreshFooterAssociatedKey) as? AKRefreshFooter
        }
        set{
            if let oldFooter = footer{
                oldFooter.removeFromSuperview()
            }
            if let footer = newValue{
                self.base.addSubview(footer)
            }
            objc_setAssociatedObject(self, &AKRefreshFooterAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    public func startHeaderAction(){
        DispatchQueue.main.async {
            self.header?.startRefresh()
        }
    }

    public func endHeaderAction(){
        DispatchQueue.main.async {
            self.header?.endRefresh()
        }
    }

    public func startFooterAction(){
        DispatchQueue.main.async {
            self.footer?.startRefresh()
        }
    }

    public func endFooterAction(){
        DispatchQueue.main.async {
            self.footer?.endRefresh()
        }
    }


}


extension UIScrollView :AKRefreshCompatible{}
