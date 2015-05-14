//
//  GoogleMapExt.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/02/21.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

class GMSMarkerExt: GMSMarker {
    
    var id:Int = 0
    
    var category:Category
    
    override init(){
        self.category = Category.FOOD
        super.init()
    }

}