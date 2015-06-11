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
    class func setMarkers(tackList:[Tack],mapView:GMSMapView) -> [GMSMarkerExt]{
        
        
        var markerList : [GMSMarkerExt] = [GMSMarkerExt]()
        
        for (var i : Int = 0; i < tackList.count; i++) {
            
            var tack : Tack = tackList[i]
            let marker: GMSMarkerExt = GMSMarkerExt ()
            marker.id = i;
            //marker.snippet = oneRecord.comment
            marker.position = CLLocationCoordinate2DMake(tack.lat, tack.lng)
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.category = tack.category
            
            switch tack.category{
            case Category.FOOD:
                marker.icon = ImageLogic.resizeImageWidth50(UIImage(named: "pin01_food"))
                break
            case Category.SCENE:
                marker.icon = ImageLogic.resizeImageWidth50(UIImage(named: "pin02_shopping"))
                break
            case Category.ACTIVITY:
                marker.icon = ImageLogic.resizeImageWidth50(UIImage(named: "pin03_activity"))
                break
            case Category.MYTACK:
                break
            default :
                break
            }
            
            //自分が立てたピンである場合
            if(isMyTack(tack)){
                tack.category = Category.MYTACK
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
    class func isMyTack(tack:Tack) -> Bool{
        if(tack.snsId == LocalDataLogic.getUUID()){
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
    
    
    //ズームを調整する
    class func ajustZoomPoint(markerList:[GMSMarkerExt],mapView:GMSMapView){
        var count = 0
        //マーカーが５個以上見えていない場合
        //ズームレベルが１５以上の場合
        while(count < 5 && mapView.camera.zoom > 15){
            count = 0
            
            mapView.moveCamera(GMSCameraUpdate.zoomOut())
            
            //レスポンスがない場合は終了
            if(markerList.count == 0){
                return
            }
            
            for ( var i = 0 ; i < markerList.count ;i++  ){
                var marker : GMSMarkerExt = markerList[i]
                if(mapView.projection.containsCoordinate(marker.position)){
                    count++
                    println(count)
                }//if
            }//for
        }//while
    }


    class func clearMarkers(mapView:GMSMapView){
        mapView.clear();
    }
    

}