//
//  Log.swift
//  jp.spinach.basho.swift.02
//
//  Created by 高橋洋樹 on 6/18/15.
//  Copyright (c) 2015 Spinach. All rights reserved.
//

import Foundation

class Log {
    
    static func debugLog(obj: AnyObject?,
        function: String = __FUNCTION__,
        line: Int = __LINE__) {
            #if DEBUG
                print("[Function:\(function) Line:\(line)] : \(obj)")
            #endif
    }
    
    static func debugStartLog(function: String = __FUNCTION__,
        line: Int = __LINE__) {
            #if DEBUG
                let format : NSDateFormatter = NSDateFormatter()
                format.dateFormat = "HH:mm:ss.SSS"
                print("[Function:\(function) Line:\(line)] - start - " + format.stringFromDate(NSDate()))
            #endif
    }
    
    static func debugEndLog(function: String = __FUNCTION__,
        line: Int = __LINE__) {
            #if DEBUG
                let format : NSDateFormatter = NSDateFormatter()
                format.dateFormat = "HH:mm:ss.SSS"
                print("[Function:\(function) Line:\(line)] - end - " + format.stringFromDate(NSDate()))
            #endif
    }
    
    static func debugLogWithTime(obj: AnyObject?,
        function: String = __FUNCTION__,
        line: Int = __LINE__) {
            #if DEBUG
                let format : NSDateFormatter = NSDateFormatter()
                format.dateFormat = "HH:mm:ss.SSS"
                print("[Function:\(function) Line:\(line)] : \(obj) :" + format.stringFromDate(NSDate()))
            #endif
    }
    
}