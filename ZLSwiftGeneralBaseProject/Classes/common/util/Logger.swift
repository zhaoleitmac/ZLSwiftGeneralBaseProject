//
//  Logger.swift
//  GGSJ
//
//  Created by 赵雷 on 2017/9/6.
//  Copyright © 2017年 com.channelsoft. All rights reserved.
//

import UIKit

class Logger: NSObject {
    
    required override init() {
        
    }
    
   public class func debug(_ items:Any...){
    
        #if (DEV)
            for item in items{
                //控制台输出中文
                if let dict = item as? [StringLiteralType:Any]{
                    print(dict)
                }else if let arr = item as? [Any]{
                    print(arr)
                }else {
                    print(item)
                }
            }
        #endif
    }
    
    public class func debugPrintMemeorySafe(obj:Any){
        self.debug("----- \(type(of: obj)) <\(obj)> memory safe -----")
    }
}
