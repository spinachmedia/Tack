//
//  SNSLogic.swift
//  jp.spinach.basho.swift.02
//
//  Created by 高橋洋樹 on H27/09/21.
//  Copyright (c) 平成27年 Spinach. All rights reserved.
//

import Foundation

struct SNSLogic {
    
    static func getSNSToken() -> String {
        //ログイン中のSNSを判定
        //FBである場合
        if(true){
            return FBSDKAccessToken.currentAccessToken().tokenString
        }
    }
    
    static func getLoginedSNSType() -> String {
        //ログイン中のSNSを判定
        //FBである場合
        if(true){
            return "FB"
        }
    }
    
}