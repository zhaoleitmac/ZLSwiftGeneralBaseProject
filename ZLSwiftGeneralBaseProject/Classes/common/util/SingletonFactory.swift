//
//  SingletonFactory.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/6.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import Foundation

protocol SingletonAvaliable {
    //    associatedtype baseOn
    init()
}


class SingletonFactory : NSObject {
    private static var singletons = [String: SingletonAvaliable]()
    
    class func getInstance<T: SingletonAvaliable>(classType:T.Type) -> T {
        let className = String(describing: classType)
        var instance:T? = self.singletons[className] as? T
        if instance == nil {
            instance = classType.init()
            self.singletons[className] = instance
        }
        return instance!
    }
}

extension SingletonAvaliable {
    
    static var `default`: Self {
        return SingletonFactory.getInstance(classType: self)
    }
    
    static var shared: Self {
        return SingletonFactory.getInstance(classType: self)
    }
    
    static var current: Self {
        return SingletonFactory.getInstance(classType: self)
    }
}
