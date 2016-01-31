//
//  Random.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/22.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation


struct Random{
    
    /**
    ユーザIDを生成する
    
    - returns: <#return value description#>
    */
    static func getObjectId() -> String{
        
        var uuid:String = NSUUID().UUIDString;
        uuid = uuid.stringByReplacingOccurrencesOfString("-", withString: "").lowercaseString
        uuid = (uuid as NSString).substringToIndex(19)
        return uuid;
    }
    
}