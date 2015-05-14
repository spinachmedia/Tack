//
//  Category.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/07.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

enum Category {
    case FOOD
    case SCENE
    case ACTIVITY
    case MYTACK
    
    func toString () -> String {
        switch self{
        case Category.FOOD:
            return "FOOD"
        case Category.SCENE:
            return "SCENE"
        case Category.ACTIVITY:
            return "ACTIVITY"
        case Category.MYTACK:
            return "MYTACK"
        default :
            return ""
        }
    }
    
    static func toCategory (str : String) -> Category {
        
        switch str{
        case "FOOD":
            return Category.FOOD
        case "SCENE":
            return Category.SCENE
        case "ACTIVITY":
            return Category.ACTIVITY
        case "MYTACK":
            return Category.MYTACK
        default :
            return Category.FOOD
        }
        
    }
    
}
    