//
//  ConvertUtil.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/10/23.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

public typealias EnConvertable = NSObject & Encodable

public typealias DeConvertable = NSObject & Decodable

public typealias Convertable = NSObject & Codable


class ConvertUtil: NSObject, SingletonAvaliable {
    
    required override init() {
        super.init()
    }
    
    var STOMappers: [String: ((Encodable) -> AnyObject)] = [String: ((Encodable) -> AnyObject)]()
    
    var OTSMappers: [String: ((AnyObject) -> Encodable)] = [String: ((AnyObject) -> Encodable)]()
    
}
//未加入Objective-C转模型框架，先注释
//extension ConvertUtil {
//    //Swift to Objective-C
//    func swiftToOC<S: EnConvertable, O: NSObject>(from: S, to: O.Type) -> O {
//        let sClass: String = String(describing: S.self)
//        let oClass: String = String(describing: to)
//        if let call = self.STOMappers[sClass + oClass] {
//            return call(from) as? O ?? O()
//        } else {
//            let dict: [String : Any]? = from.zl.jsonDictionary()
//            let instance = O()
//            instance.cl_setValues(dict ?? [:])
//            return instance
//        }
//    }
//
//    func swiftsToOCs<S: EnConvertable, O: NSObject>(from: [S], to: O.Type) -> [O] {
//        return from.map {self.swiftToOC(from: $0, to: to)}
//    }
//
//}
//
//extension ConvertUtil {
//    //Objective-C to Swift
//    func OCToSwift<O: NSObject, S: DeConvertable>(from: O, to: S.Type) -> S {
//        let oClass: String = String(describing: O.self)
//        let sClass: String = String(describing: to)
//        if let call = self.OTSMappers[oClass + sClass] {
//            return call(from) as? S ?? S()
//        } else {
//            let dict: [String : Any]? = from.cl_dictionary() as? [String : Any]
//            let instance = to.zl.instance(with: dict ?? [:])
//            return instance ?? S()
//        }
//    }
//
//    func OCsToSwifts<O: NSObject, S: DeConvertable>(from: [O], to: S.Type) -> [S] {
//        return from.map {self.OCToSwift(from: $0, to: to)}
//    }
//}

