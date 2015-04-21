//
//  InfoViewDetailViewController.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/29.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class InfoViewDetailViewController: UIViewController {
    

    var subViewHeight:CGFloat = 0
    @IBOutlet weak var scView: UIScrollView!
    
    //前画面から渡される値
    var objectId : String = ""
    var counter : String = "0"
    
    var placeText: String?
    var bodyText: String?
    var image: UIImage?
    var time: String?
    
    
    //表示項目
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var tackTime: UILabel!
    @IBOutlet weak var footerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        counterLabel.text = counter
        
        place.text = placeText
        imageView.image = image
        body.text = bodyText
        
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyBoard")
        self.view.addGestureRecognizer(gestureRecognizer)
        
        
        //コメントの取得
        self.getReply()
    }
    
    func closeKeyBoard(){
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //TextView(Body)のサイズを再設定
        var rect = body.frame
        rect.size.height = body.contentSize.height
        body.frame = rect
        
        //tackTimeの位置を再設定
        var timeRect = self.tackTime.frame
        timeRect.origin.y = body.frame.origin.y + body.frame.size.height
        self.tackTime.frame = timeRect

        
        //footerViewの位置を再設定
        var footerRect = self.footerView.frame
        footerRect.origin.y = tackTime.frame.origin.y + tackTime.frame.size.height
        self.footerView.frame = footerRect
        
        //スクロールビューの領域を更新
        self.scView.contentSize.height = footerRect.origin.y + footerRect.size.height
        
        self.scView.contentSize.height = CGFloat(self.subViewHeight)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        var rect = body.frame
        rect.size.height = body.contentSize.height
        body.frame = rect
    }

    
    //GoodTack機能の実装
    
    @IBOutlet weak var goodTack: UIButton!
    @IBAction func goodTack(sender: AnyObject) {
        
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "GoodTackSending..."
        
        let manager:AFHTTPRequestOperationManager = HTTPManager.HTTPRequestManagerFactory()
        
        var commentParams: Dictionary = [
            "tack_point" :   (counter.toInt()! + 1)
        ]
        
        manager.PATCH(Setting.UPDATE_COMMENT_URL + "/" + self.objectId, parameters: commentParams,
            success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                self.counter = String(self.counter.toInt()! + 1)
                self.counterLabel.text = self.counter
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                println("error: \(error)")
                //TODO:容量オーバーの時の処理
                //TODO:404の時の処理
                //TODO:タイムアウトの時の処理
                //TODO:その他エラーの時の処理
        })
    }
    
    
    //返信機能の実装
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func replyButton(sender: AnyObject) {
        self.sendReply()
    }
    
    func sendReply(){
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "SendingReply..."
        
        let manager:AFHTTPRequestOperationManager = HTTPManager.HTTPRequestManagerFactory()
        
        var commentParams: Dictionary = [
            "object_id": objectId,
            "user_id" : LocalDataLogic.getUUID(),
            "comment": self.textField.text,
        ]
        
        manager.POST(Setting.SET_REPLY_URL, parameters: commentParams,
            success: {(operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                println("response:\(responseObject)")
                self.getReply()
                return
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                println("error: \(error)")
                //TODO:容量オーバーの時の処理
                //TODO:404の時の処理
                //TODO:タイムアウトの時の処理
                //TODO:その他エラーの時の処理
        })

    }
    
    @IBOutlet weak var replyViewArea: UIView!
    
    var jsonData :JSON?
    
    func getReply(){
        let manager:AFHTTPRequestOperationManager = HTTPManager.HTTPRequestManagerFactory()
        var query = Setting.GET_REPLY_URL + "object_id.eq." + objectId
        manager.GET(query , parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                println(responseObject)
                self.jsonData = JSON(responseObject)
                self.setReplyArea()
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("error: \(error)")
            }
        )
    }
    
    func setReplyArea(){
        //コメントがない場合
        if(jsonData==nil){
            //まだコメントがありません
            return
        }
        if(jsonData!["_total"] == 0){
            //まだコメントがありません
            return
        }else{
            //データの数だけループ
            var screenWidth = UIScreen.mainScreen().bounds.width
            var positionY:CGFloat = 0
            
            for(var i = 0 ;i < self.jsonData!["_total"].stringValue.toInt();i++){
                println("render")
                var view:ReplyView = UINib(nibName: "ReplyView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as ReplyView
                
                view.count.text = String(i)
                view.body.text  = self.jsonData!["_objs"][i]["comment"].string
                view.time.text  = self.jsonData!["_objs"][i]["_uts"].string
                
                //Bodyの高さを更新
                
                //1リプライ分の高さを表示
                var size = view.count.frame.height + view.body.frame.height + view.time.frame.height
                
                var frame : CGRect  = CGRectMake(0, positionY, screenWidth, size)
                view.frame = frame
                positionY = positionY + size
                replyViewArea.addSubview(view)
            }
            //コメントエリアのサイズ
            replyViewArea.sizeToFit()
            self.subViewHeight = positionY + footerView.frame.origin.y + 64

        }//if
    }//func
}//class