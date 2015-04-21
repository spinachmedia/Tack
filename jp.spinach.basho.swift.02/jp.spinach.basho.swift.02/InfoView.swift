//
//  InfoView.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/24.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class InfoView: UIView {

    @IBOutlet weak var backBoard: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    func setViews(title:String,body:String,imageUrl:String,imageFlg:Bool){
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.backBoard.layer.cornerRadius = 10
        self.backBoard.clipsToBounds = true
        self.backBoard.layer.shadowOffset = CGSizeMake(0,10)
        self.backBoard.layer.shadowRadius = 10
        self.backBoard.layer.shadowOpacity = 0.8
        
//        self.imageView.layer.cornerRadius = imageView.frame.size.width / 2
//        self.imageView.clipsToBounds = true
        
        self.title.text = title
        
        if(imageFlg){
            let url = NSURL(string: imageUrl)
            let imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
            let uiImage = UIImage(data: imageData!)
            self.imageView.image = uiImage

//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//                let url = NSURL(string: imageUrl)
//                let imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
//                let uiImage = UIImage(data: imageData!)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.imageView.image = uiImage
//                    println(self.imageView.image!)
//                })
//            })
        }
        self.textView.text = body
    }
}
