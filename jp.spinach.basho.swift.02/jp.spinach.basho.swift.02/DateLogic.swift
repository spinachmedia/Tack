//
//  DateLogic.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/05/14.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

struct DateLogic {
    
    static func string2Date (str :String) -> NSDate{
        
        var df : NSDateFormatter = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "ja")
        df.timeZone = NSTimeZone(abbreviation: "GMT")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return df.dateFromString(str)!
        
    }
    
    static func date2String (date :NSDate) -> String{
        
        var df : NSDateFormatter = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        df.timeZone = NSTimeZone.localTimeZone()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return df.stringFromDate(date).stringByAppendingString("Z")
    }
    
    static func date2StringForView (date :NSDate) -> String{
        
        var df : NSDateFormatter = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        df.timeZone = NSTimeZone.localTimeZone()
        df.dateFormat = "yyyy/MM/dd HH:mm"
        
        return df.stringFromDate(date)
    }

    
}