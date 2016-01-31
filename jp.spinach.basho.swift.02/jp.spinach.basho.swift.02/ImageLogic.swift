//
//  ImageLogic.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/22.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

struct ImageLogic {
    
    /**
    画像を圧縮して返す。
    横幅を400以下にする
    
    - parameter image: <#image description#>
    
    - returns: <#return value description#>
    */
    static func resizeIamgeWidth300(image:UIImage?) -> NSData{
        
        var resizePar = 300 / image!.size.width
        
        //リサイズ
        var size:CGSize = CGSizeMake(
            image!.size.width * resizePar,
            image!.size.height * resizePar
        )
        
        //画像の縮小
        UIGraphicsBeginImageContext(size)
        image!.drawInRect(CGRectMake(0,0,size.width,size.height))
        var imageResized:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //画像の圧縮
        let imageData :NSData = UIImageJPEGRepresentation(imageResized, 0.4)!

        return imageData
    }
    
    /**
    ピン用の画像圧縮
    UIIMage(PNG)で返す
    
    - parameter image: <#image description#>
    
    - returns: <#return value description#>
    */
    static func resizeImageWidth50(image:UIImage?) -> UIImage{
        
        let resizePar = 50 / image!.size.width
        
        //リサイズ
        let size:CGSize = CGSizeMake(
            image!.size.width * resizePar,
            image!.size.height * resizePar
        )
        
        //画像の縮小
        UIGraphicsBeginImageContext(size)
        image!.drawInRect(CGRectMake(0,0,size.width,size.height))
        let imageResized:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //画像の圧縮
        let imageData :NSData = UIImagePNGRepresentation(imageResized)!//UIImageJPEGRepresentation(imageResized, 0.4)
        return UIImage(data: imageData)!
    }
    
    /**
    ピン用の画像圧縮
    UIIMage(PNG)で返す
    
    - parameter image: <#image description#>
    
    - returns: <#return value description#>
    */
    static func resizeImageWidth80(image:UIImage?) -> UIImage{
        
        let resizePar = 80 / image!.size.width
        
        //リサイズ
        let size:CGSize = CGSizeMake(
            image!.size.width * resizePar,
            image!.size.height * resizePar
        )
        
        //画像の縮小
        UIGraphicsBeginImageContext(size)
        image!.drawInRect(CGRectMake(0,0,size.width,size.height))
        let imageResized:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //画像の圧縮
        let imageData :NSData = UIImagePNGRepresentation(imageResized)!//UIImageJPEGRepresentation(imageResized, 0.4)
        return UIImage(data: imageData)!
    }
    
}