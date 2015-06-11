//  Setting.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/21.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

struct Setting {
    
    //20150510 サーバを変更
    static let SERVER_URL = "http://tack.spinachmedia.info"
    static let SERVER_PORT = "3000"

    static let GET_TACK = "/api/getTack"
    static let GET_MY_TACK = "/api/getMyTack"
    static let GET_REPLY = "/api/getReply"
    
    static let POST_TACK = "/api/postTack"
    static let POST_REPLY = "/api/postReply"
    static let POST_GOOD = "/api/postGood"
    
    
    /// Local Html Path etc...
    static let LOCAL_TAG_HTML = "html"
    static let LOCAL_HTML_TACKLIST = "html/selfTack"
    
    static let LOCAL_INFOWINDOW_FB_NAME = "html/faceBookName"
    
    ///LocalHtmlMethodName
//    static let JS_TACKLIST_GET_TACK = "getTackList"
//    static let JS_LEFT = "("
//    static let JS_RIGHT = ")"
    
    
}
