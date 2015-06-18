//
//  InfoView.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/24.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    //--------------------
    
    //受け取ったTack情報
    var tack: Tack?
    //要素
    var category : Category = Category.FOOD
    
    @IBOutlet weak var bgImage: UIImageView!
    
    //背景
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundArrow: UIView!
    
    //SNSエリア
    @IBOutlet weak var snsIcon: UIImageView!
    @IBOutlet weak var snsName: UILabel!
    @IBOutlet weak var snsTime: UILabel!
    
    //TACKエリア
    @IBOutlet weak var tackTitle: UILabel!
    @IBOutlet weak var tackBody: UITextView!
    @IBOutlet weak var tackImage: UIImageView!
    
    //COUNT
    @IBOutlet weak var goodTackCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    func initialize(tack:Tack){

        self.setUp(tack)
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            
//        })
    }
    
    func setUp(tack:Tack){
        Log.debugStartLog()
        self.tack = tack
        
        if tack.snsId != "" {
            
            if(tack.snsCategory == "FB" || tack.snsCategory == "fb" ){
                //画像と表示名のセット
                setFBProfile(tack.snsId);
                self.snsName.text = tack.snsName
                
            }

        }

        self.category = tack.category
        self.tackTitle.text = tack.placeName
        self.tackBody.text = tack.comment
        self.goodTackCount.text = String(tack.goodTackCount)
        self.commentCount.text = String(tack.commentCount)
        if(tack.hasFileFlg){
            self.tackImage.contentMode = UIViewContentMode.ScaleAspectFit
            if let image = HTTPLogic.getImage(tack.filePath) {
               self.tackImage.image = HTTPLogic.getImage(tack.filePath)!
            }
        }
        self.snsTime.text = DateLogic.date2StringForView(tack.date)
        

        switch self.category {
        case Category.FOOD:
            self.bgImage.image = UIImage(named: "fukidasi_pink.png")!
            break;
        case Category.SCENE:
            self.bgImage.image = UIImage(named: "fukidasi_brue.png")!
            break;
        case Category.ACTIVITY:
            self.bgImage.image = UIImage(named: "fukidasi_yellow.png")!
            break;
        case Category.MYTACK:
            break;
        }
        
        Log.debugEndLog()
        
    }
    
    
    func setFBProfile(id:String){
        Log.debugStartLog()
        var urlString : String = "https://graph.facebook.com/" + id + "/picture"
        var url : NSURL? = NSURL(string: urlString)
        var data : NSData? = NSData(contentsOfURL: url!)
        if let id = data {
            //println("OK")
            var snsImage : UIImage? = UIImage(data: data!)
            snsIcon.image = snsImage!
        }
        Log.debugEndLog()
    }

}
