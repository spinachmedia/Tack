//
//  LocalDataLogic.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/30.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation


struct LocalDataLogic {
    /**
    初回起動かどうかチェック
    初回起動ならtrue
    */
    static func isStartUp() -> Bool{
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var result : Bool = defaults.boolForKey("start_up")

        if(result){
            return false
        }else{
            return true
        }
    }
    
    /**
    起動
    */
    static func startUped(){
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "start_up")
    }
    
    static func setUUID(){
        if(isStartUp()){
        }else{
            var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(NSUUID().UUIDString, forKey: "user_id")
        }
    }
    static func getUUID() -> String{
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let result : String? = defaults.stringForKey("user_id")!
        println(result!)
        return result!
    }
}