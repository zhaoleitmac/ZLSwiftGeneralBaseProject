//
//  UIDevice+ZLExtension.swift
//  citizen
//
//  Created by liuchang on 2016/11/10.
//  Copyright © 2016年 com.qmlw. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public class ZLExtension<Base> {
    
    public let base: Base
    
    public init(_ base:Base) {
        self.base = base
    }

}
public protocol ZLExtensionCompatible {
    
    associatedtype ZLExtensionCompatibleType
    static var zl: ZLExtension<ZLExtensionCompatibleType>.Type{get set}
    var zl: ZLExtension<ZLExtensionCompatibleType>{get set}
    
}

extension ZLExtensionCompatible {
    
    public static var zl: ZLExtension<Self>.Type{
        get {
            return ZLExtension<Self>.self
        }
        set {

        }
    }
    public var zl: ZLExtension<Self> {
        get {
            return ZLExtension(self)
        }
        set {

        }
    }
}

extension NSObject: ZLExtensionCompatible {}



