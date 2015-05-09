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
    
    //要素
    var category : Category = Category.FOOD
    
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
    
    func setViews(title:String,body:String,imageUrl:String,imageFlg:Bool){
        
        var bgColor : UIColor?
        var borderColor : UIColor?
        var pictureBgColor : UIColor?
        
//        switch (category) {
//        case Category.FOOD :
//            bgColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            borderColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            pictureBgColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            break;
//        case Category.SCENE :
//            bgColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            borderColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            pictureBgColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            break;
//        case Category.ACTIVITY :
//            bgColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            borderColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            pictureBgColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            break;
//        default :
//            bgColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            borderColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            pictureBgColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//            break;
//        }
        
        //背景の設定
//        self.backgroundView.layer.borderWidth = 2
//        self.backgroundView.layer.borderColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1).CGColor!
    
        self.backgroundView.layer.cornerRadius = 0
        self.backgroundView.clipsToBounds = true
//        self.backgroundView.layer.shadowOffset = CGSizeMake(0,10)
//        self.backgroundView.layer.shadowRadius = 10
//        self.backgroundView.layer.shadowOpacity = 0.8
        
        //背景の矢印の設定
//        self.sendSubviewToBack(self.backgroundArrow)
//        self.backgroundArrow.backgroundColor = UIColor(red: 255/255, green: 112/255, blue: 228/255, alpha: 1)
//        self.backgroundArrow.layer.cornerRadius = 50
        
        //TACKの内容
        self.tackTitle.text = title
        self.tackBody.text = body
        self.tackImage.contentMode = UIViewContentMode.ScaleAspectFit
        if(imageFlg){
            let url = NSURL(string: imageUrl)
            let imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
            let uiImage = UIImage(data: imageData!)
            self.tackImage.image = uiImage
        }
        
        
        
    }
}
