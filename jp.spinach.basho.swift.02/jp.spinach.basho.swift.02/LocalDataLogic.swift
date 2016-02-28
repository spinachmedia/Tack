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
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let result : Bool = defaults.boolForKey("start_up")

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
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "start_up")
    }
    
    static func getFBAccessTokenDictionary() -> NSDictionary? {
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let data : NSData? = defaults.dataForKey("accsess_token")
        if let a = data {
            let token : NSDictionary? = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSDictionary?
            return token
        }else{
            return nil
        }
    }
    
    static func setFBAccessTokenDictionary(token : NSDictionary?){
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let classData : NSData = NSKeyedArchiver.archivedDataWithRootObject(token!)
        defaults.setObject(classData,forKey: "accsess_token")
        defaults.synchronize()
    }
    
    static func setSnsId(snsId:String!){
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(snsId!, forKey: "sns_id")
    }
    static func getSnsId() -> String{
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let result : String? = defaults.stringForKey("sns_id")!
        return result!
    }
    
    
    static func setSnsName(snsId:String!){
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(snsId!, forKey: "sns_name")
    }
    static func getSnsName() -> String{
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let result : String? = defaults.stringForKey("sns_name")
        if let a = result {
            return result!
        }
        return ""
    }
    
    
    static func setUUID(){
        if(isStartUp()){
        }else{
            let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(NSUUID().UUIDString, forKey: "user_id")
        }
    }
    static func getUUID() -> String{
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let result : String? = defaults.stringForKey("user_id")!
        //println(result!)
        return result!
    }
}