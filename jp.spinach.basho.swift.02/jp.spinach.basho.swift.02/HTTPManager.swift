//
//  HTTPManager.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/07.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

/**
*  HTTPリクエスト、レスポンスの制御
*/
class HTTPManager {
    
    class func HTTPRequestManagerFactory() -> AFHTTPRequestOperationManager{
        
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let serializer:AFJSONRequestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = serializer
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return manager
        
    }
    
}