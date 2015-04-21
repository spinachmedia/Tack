//
//  Setting.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/21.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

struct Setting {
    
    static let DATASTORE_ID         = "_sandbox";
    static let APPLICATION_ID       = "Basho";
    static let APPLICATION_TOKEN    = "app259a60881817bd612ac7c6fd10";
    
    static let COMMENT_STORAGE      = "comment_latlng"
    static let FILE_STORAGE         = "image_latlang"
    
    static let GET_COMMENT_URL      = "https://api-datastore.appiaries.com/v1/dat/_sandbox/Basho/comment_latlng/-;"
    
    static let SET_COMMENT_URL      = "https://api-datastore.appiaries.com/v1/dat/_sandbox/Basho/comment_latlng"
    
    
    static let GET_REPLY_URL      = "https://api-datastore.appiaries.com/v1/dat/_sandbox/Basho/reply_latlang/-;"
    
    static let SET_REPLY_URL      = "https://api-datastore.appiaries.com/v1/dat/_sandbox/Basho/reply_latlang"
    
    static let UPDATE_COMMENT_URL      = "https://api-datastore.appiaries.com/v1/dat/_sandbox/Basho/comment_latlng"
    
    static let SET_IMAGE_URL        = "https://api-datastore.appiaries.com/v1/bin/_sandbox/Basho/image_latlang"
    
    static let IMAGE_URL_WITH_OBJECT_ID = "https://api-datastore.appiaries.com/v1/bin/_sandbox/Basho/image_latlang/"
    
}
