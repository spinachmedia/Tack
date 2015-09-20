//
//  Tack.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/05/14.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation

class Tack{
    
    var objectId : String = ""
    var tackId : String = ""
    
    //FBのIDなど
    var snsId : String = ""
    var snsCategory : String = "fb"
    var snsImage : UIImage = UIImage();
    
    var category : Category = Category.FOOD
    var placeName : String = ""
    var comment : String = ""
    var goodTackCount : Int = 0
    var commentCount : Int = 0
    var cityCode : String = "00000"
    var lat : Double = 30.0
    var lng : Double = 130.0
    
    //写真を持っているかどうか
    var hasFileFlg : Bool = false
    var filePath : String = "http://tack.spinachmedia.info:3000/img.png"
    var image : UIImage = UIImage()
    
    var date : NSDate = NSDate();
    
    
    //addingparams
    var snsName : String = ""

    
    func initialize(json : JSON){
        
        if let id = json["tack_id"].string {
            tackId = json["tack_id"].string!
        }
        if let id = json["sns_id"].string {
            snsId = json["sns_id"].string!
        }
        if let id = json["sns_category"].string {
            snsCategory = json["sns_category"].string!
        }
        if let id = json["category"].string {
            category =  Category.toCategory(json["category"].string!)
        }
        if let id = json["place_name"].string {
            placeName = json["place_name"].string!
        }
        if let id = json["comment"].string {
            comment = json["comment"].string!
        }
        if let id = json["good_tack"].int {
            goodTackCount = json["good_tack"].int!
        }
        if let id = json["comment_count"].int {
            commentCount = json["comment_count"].int!
        }
        if let id = json["city_code"].string {
            cityCode = json["city_code"].string!
        }
        if let id = json["lat"].float {
            lat = Double(json["lat"].float!)
        }
        if let id = json["lng"].float {
            lng = Double(json["lng"].float!)
        }
        if let id = json["has_file_flg"].int {
            hasFileFlg = json["has_file_flg"].int! == 1 ? true : false
        }
        if let id = json["file_path"].string {
            filePath = json["file_path"].string!
        }
        if let id = json["date"].string {
            date = DateLogic.string2Date(json["date"].string!)
        }
        
        
        //名前を取得しておく。
        //InfoWindow描画後にUIを変更できないため、この段階で情報を取得しておく。
        if(snsCategory == "FB" || snsCategory == "fb"){
            var req = FBSDKGraphRequest(graphPath: "/" + snsId ,
                parameters: nil,
                HTTPMethod: "GET")

            req.startWithCompletionHandler(
                { (connection, result, err) -> Void in
                    var json : JSON = JSON(result)
                    self.snsName = json["name"].stringValue
                }
            )
        }

        
    }
    
    
    //非同期で画像を取りに行く
    func getImages(){
        getSNSImage()
        getImage()
    }
    
    func getSNSImage(){
        if(self.snsCategory == "FB" || self.snsCategory == "fb" ){
            setFBProfile(self.snsId);
        }else{
            //twitterなどの画像取得…？
            
        }
    }
    
    
    func getImage(){
        if(self.hasFileFlg){
            if let image = HTTPLogic.getImage(self.filePath) {
               self.image = image
            }
        }
    }
    
    
    //ここか地獄のように重い。
    //タップしてからの取得ではユーザビリティが非常に悪くなる。
    //事前に非同期で取得しておく必要がある。
    func setFBProfile(id:String){
        Log.debugStartLog()
        var urlString : String = "https://graph.facebook.com/" + id + "/picture"
        var url : NSURL? = NSURL(string: urlString)
        var data : NSData? = NSData(contentsOfURL: url!)
        if let id = data {
            var snsImage : UIImage? = UIImage(data: data!)
            self.snsImage = snsImage!
        }
        Log.debugEndLog()
    }
    
    
    //
    
    
    static func tackListFactory(responseObject:AnyObject!) -> [Tack] {
        var tackList : [Tack] = [Tack]()
        let json = JSON(responseObject)
        for (var i : Int = 0; i < json["items"].count; i++) {
            var tack : Tack = Tack()
            tack.initialize(json["items"][i])
            tackList.append(tack)
        }
        return tackList
    }
    
    //TackListからTackIdを元にデータを取り出す
    static func getTackFromListWithTackId(list:[Tack],tackId:String) -> Tack?{
        for (var i : Int = 0; i < list.count; i++) {
            if(list[i].tackId == tackId){
                return list[i]
            }
        }
        return nil
    }
    
    //TODO ダミーメソッド
    static func getNearTackList(count : Int,lat : Double, lng: Double, list : [Tack]) -> [Int]{
        
        var result : [Int] = []
        
        //ID:距離
        var tmp : [Double] = []
        
        //距離を配列に格納
        for var i = 0 ;i < list.count ; i++ {
            var tack : Tack = list[i]
            //距離を算出
            var dist : Double = ( (lat - tack.lat) * (lat - tack.lat) + (lng - tack.lng) * (lng - tack.lng) )
            tmp.append(dist);
        }
        
        //距離順でソート
        
        //近い順にIDを取り出す
        for var i = 0 ;i < list.count ; i++ {
            result.append(i)
        }

        return result
    }
    
    
}