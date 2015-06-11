//
//  HTTPLogic.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/05.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

struct HTTPLogic {
    
    static func HTTPRequestManagerFactory() -> AFHTTPRequestOperationManager{
        
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let serializer:AFJSONRequestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer = serializer
        
        
        return manager
        
    }
    
    
    ///Tackリストを取得する
    static func getTackRequest(
        sns_id:String,
        lat:CLLocationDegrees,
        lng:CLLocationDegrees,
        count:Int,
        callBack:(operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void
        ){
            
            let url = Setting.SERVER_URL + ":" + Setting.SERVER_PORT + Setting.GET_TACK
            
            var manager : AFHTTPRequestOperationManager = HTTPRequestManagerFactory();
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //パラメータ生成
            var params: Dictionary = [
                "sns_id": sns_id,
                "lat": NSString(format: "%.15f", lat),
                "lng": NSString(format: "%.15f", lng),
                "count": count
            ]
            
            //リクエスト送信
            manager.GET(url, parameters: params,
                success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                    //クロージャの呼び出し
                    callBack(operation: operation,responseObject: responseObject)
                    
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("error: \(error)")
                }
            )
    }
    
    //Tackする
    static func postTackRequest(
        sns_id:String,
        category: Category,
        placeName: String,
        comment: String,
        lat:CLLocationDegrees,
        lng:CLLocationDegrees,
        fileData: NSData!,
        callBack:(operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void
        ){
            
            let url = Setting.SERVER_URL + ":" + Setting.SERVER_PORT + Setting.POST_TACK
            
            var manager : AFHTTPRequestOperationManager = HTTPRequestManagerFactory();
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //パラメータ生成
            var params: Dictionary = [
                "sns_id": sns_id,
                "category": category.toString(),
                "place_name": placeName,
                "comment": comment,
                "lat": NSString(format: "%.15f", lat),
                "lng": NSString(format: "%.15f", lng),
            ]
            
            var fileName = NSUUID().UUIDString + ".png"
            
            if(fileData != nil){
                //リクエスト送信
                manager.POST(url, parameters: params,
                    constructingBodyWithBlock: { (formData : AFMultipartFormData!) -> Void in
                        formData.appendPartWithFileData(fileData, name: "file_data", fileName: fileName, mimeType: "image/jpeg")
                    },
                    success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                        callBack(operation: operation,responseObject: responseObject)
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        println("error: \(error)")
                    }
                )
            }else{
                //リクエスト送信
                manager.POST(url, parameters: params,
                    success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                        callBack(operation: operation,responseObject: responseObject)
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        println("error: \(error)")
                    }
                )
            }
           
            
    }
    
    static func getImage(path : String) -> UIImage?{
        let url = NSURL(string: Setting.SERVER_URL + ":" + Setting.SERVER_PORT + "/" + path)
        let imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        if let id = imageData {
            let uiImage = UIImage(data: imageData!)
            return uiImage
        }else{
            return nil
        }
    }
    
    
}