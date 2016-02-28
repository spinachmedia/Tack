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
    
    static func getTack(tackId: String,
        callBack:(operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void){
            
            let url = Setting.SERVER_URL + ":" + Setting.SERVER_PORT + Setting.GET_TACK_ONE
            
            let manager : AFHTTPRequestOperationManager = HTTPRequestManagerFactory();
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //パラメータ生成
            let params: Dictionary = [
                "sns_id": LocalDataLogic.getSnsId(),
                "SNSType": SNSLogic.getLoginedSNSType(),
                "token": SNSLogic.getSNSToken(),
                "tackId": tackId
            ]
            
            //リクエスト送信
            manager.GET(url, parameters: params,
                success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                    //クロージャの呼び出し
                    callBack(operation: operation,responseObject: responseObject)
                    
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                    print("error: \(error)")
                }
            )

        
    }
    
    static func getMyTack(callBack:(operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void){
            
            let url = Setting.SERVER_URL + ":" + Setting.SERVER_PORT + Setting.GET_MY_TACK
            
            let manager : AFHTTPRequestOperationManager = HTTPRequestManagerFactory();
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //パラメータ生成
            let params: Dictionary = [
                "sns_id" : LocalDataLogic.getSnsId(),
                "SNSType" : SNSLogic.getLoginedSNSType(),
                "start" : "0",
                "count" : "30",
                "token" : SNSLogic.getSNSToken(),
            ]
            
            //リクエスト送信
            manager.GET(url, parameters: params,
                success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                    //クロージャの呼び出し
                    callBack(operation: operation,responseObject: responseObject)
                    
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                    print("error: \(error)")
                }
            )
            
            
    }
    
    
    ///Tackリストを取得する
    static func getTackRequest(
        lat:CLLocationDegrees,
        lng:CLLocationDegrees,
        count:Int,
        callBack:(operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void
        ){
            let sns_id = LocalDataLogic.getSnsId();
            
            let url = Setting.SERVER_URL + ":" + Setting.SERVER_PORT + Setting.GET_TACK
            
            let manager : AFHTTPRequestOperationManager = HTTPRequestManagerFactory();
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //パラメータ生成
            let params: Dictionary = [
                "sns_id": sns_id,
                "lat": NSString(format: "%.15f", lat),
                "lng": NSString(format: "%.15f", lng),
                "SNSType": SNSLogic.getLoginedSNSType(),
                "token": SNSLogic.getSNSToken(),
                "count": count
            ]
            
            //リクエスト送信
            manager.GET(url, parameters: params,
                success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                    //クロージャの呼び出し
                    callBack(operation: operation,responseObject: responseObject)
                    
                }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                    print("error: \(error)")
                }
            )
    }
    
    //Tackする
    static func postTackRequest(
        category: Category,
        placeName: String,
        comment: String,
        lat:CLLocationDegrees,
        lng:CLLocationDegrees,
        fileData: NSData!,
        callBack:(operation: AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void
        ){
            let sns_id = LocalDataLogic.getSnsId();
            
            let url = Setting.SERVER_URL + ":" + Setting.SERVER_PORT + Setting.POST_TACK
            
            let manager : AFHTTPRequestOperationManager = HTTPRequestManagerFactory();
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            manager.responseSerializer.setValue("text/html", forKey: <#String#>)
            var set : Set<NSObject> = Set<NSObject>()
            set.insert("text/html")
            set.insert("application/json")
            manager.responseSerializer.acceptableContentTypes = set
            
            //パラメータ生成
            let params: Dictionary = [
                "sns_id": sns_id,
                "category": category.toString(),
                "place_name": placeName,
                "comment": comment,
                "lat": NSString(format: "%.15f", lat),
                "lng": NSString(format: "%.15f", lng),
                "SNSType": SNSLogic.getLoginedSNSType(),
                "token": SNSLogic.getSNSToken(),
            ]
            
            let fileName = NSUUID().UUIDString + ".png"
            
//            manager.responseSerializer.acceptableContentTypes = manager.responseSerializer.acceptableContentTypes.//("text/html");
            
            if(fileData != nil){
                //リクエスト送信
                manager.POST(url, parameters: params,
                    constructingBodyWithBlock: { (formData : AFMultipartFormData!) -> Void in
                        formData.appendPartWithFileData(fileData, name: "file_data", fileName: fileName, mimeType: "image/jpeg")
                    },
                    success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                        callBack(operation: operation,responseObject: responseObject)
                    },
                    failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                        print("error: \(error)")
                    }
                )
            }else{
                //リクエスト送信
                manager.POST(url, parameters: params,
                    success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                        callBack(operation: operation,responseObject: responseObject)
                    },
                    failure: { (operation: AFHTTPRequestOperation?, error: NSError!) in
                        print("error: \(error)")
                    }
                )
            }
           
            
    }
    
    static func getImage(path : String) -> UIImage?{
        let url = NSURL(string: Setting.SERVER_URL + ":" + Setting.SERVER_PORT + "/" + path)
        let imageData = try? NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
        if let id = imageData {
            let uiImage = UIImage(data: imageData!)
            return uiImage
        }else{
            return nil
        }
    }
    
    
}