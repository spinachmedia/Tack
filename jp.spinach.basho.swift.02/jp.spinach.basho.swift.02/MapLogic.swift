//
//  MapLogic.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/07.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

/**
*  地図の制御のロジック
*/
class MapLogic {
    
    /**
    JSONで渡した値でピンを立てる。
    
    :param: jsonStr <#jsonStr description#>
    :param: mapView <#mapView description#>
    */
    class func setMarkers(jsonStr:AnyObject,mapView:GMSMapView) -> [GMSMarkerExt]{
        
        let json = JSON(jsonStr)
        
        var markerList : [GMSMarkerExt] = [GMSMarkerExt]()
        
        for (var i : Int = 0; i < json["items"].count; i++) {
            
            var oneRecord = json["items"][i]
            let marker: GMSMarkerExt = GMSMarkerExt ()
            marker.id = i;
            marker.snippet = oneRecord["comment"].string
            marker.position = CLLocationCoordinate2DMake(atof(oneRecord["lat"].stringValue), atof(oneRecord["lng"].stringValue))
            marker.appearAnimation = kGMSMarkerAnimationPop;
            
            if(oneRecord["category"] == "FOOD"){
                marker.category = Category.FOOD
                //marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                marker.icon = ImageLogic.resizeImageWidth50(UIImage(named: "pin01_food"))
            }else if(oneRecord["category"] == "SCENE"){
                marker.category = Category.SCENE
                //marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                marker.icon = ImageLogic.resizeImageWidth50(UIImage(named: "pin02_shopping"))
            }else if(oneRecord["category"] == "ACTIVITY"){
                marker.category = Category.ACTIVITY
                //marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
                marker.icon = ImageLogic.resizeImageWidth50(UIImage(named: "pin03_activity"))
            }
            
            //自分が立てたピンである場合
            if(isMyTack(oneRecord)){
                marker.category = Category.MYTACK
                marker.icon = ImageLogic.resizeImageWidth50(UIImage(named: "pin04_mytack"))
            }
            
            marker.map = mapView;
            
            markerList.append(marker)
            
        }
        
        return markerList
    }
    
    /**
    自分のピンかどうかを確認する
    
    :param: oneRecord <#oneRecord description#>
    
    :returns: <#return value description#>
    */
    class func isMyTack(oneRecord:JSON) -> Bool{
        if(oneRecord["sns_id"].string == LocalDataLogic.getUUID()){
            return true
        }
        return false
    }
    
    //カテゴリーのピンの表示状態をON/OFFする
    class func filterCategory(list:[GMSMarkerExt],category:Category,map:GMSMapView,showFlg:Bool){
        if(showFlg == true){
            for marker : GMSMarkerExt in list {
                switch(marker.category){
                    case category:
                        //marker.layer.hidden = false
                        marker.map = map
                        break;
                    default:
                        break;
                }
            }
        }else{
            for marker : GMSMarkerExt in list {
                switch(marker.category){
                case category:
                    //marker.layer.hidden = true
                    marker.map = nil
                    break;
                default:
                    break;
                }
            }
        }
    }
    
    class func clearMarkers(mapView:GMSMapView){
        mapView.clear();
    }

}