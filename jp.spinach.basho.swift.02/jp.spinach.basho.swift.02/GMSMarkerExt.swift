//
//  GoogleMapExt.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/02/21.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

class GMSMarkerExt: GMSMarker {
    
    //ID
    //Index。読み込んだ順番
    var id:Int = 0
    
    //TackId
    //サーバから取得したデータに含まれる。
    var tackId:String = ""
    
    var category:Category
    
    override init(){
        self.category = Category.FOOD
        super.init()
    }
    
    
    static func getGMSMarkerExtFromList (list:[GMSMarkerExt],tackId:String) -> GMSMarkerExt? {
        for (var i : Int = 0; i < list.count; i++) {
            if(list[i].tackId == tackId){
                return list[i]
            }
        }
        return nil
    }

}