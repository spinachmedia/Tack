//
//  NearTackListView.swift
//  jp.spinach.basho.swift.02
//
//  Created by 高橋洋樹 on 5/31/15.
//  Copyright (c) 2015 Spinach. All rights reserved.
//

import UIKit

class NearTackListView: UIView {
    
    var parentController : MainViewController?
    
    @IBOutlet var selfView: NearTackListView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var scView: UIScrollView!
    
    //Listの中身をindexiesの順番に取り出してScrolleViewに登録する
    func initialize (list: [Tack], indexies : [Int], controller : MainViewController) {
        Log.debugStartLog()
        
        parentController = controller
        
        for view in self.scView.subviews {
            view.removeFromSuperview()
        }
        
        //くるくるを表示
        MBProgressHUD.showHUDAddedTo(self, animated: true)
        
        //スクロールビューをリセットする
        dispatch_async(dispatch_get_main_queue(),{
            self.scView.contentSize = CGSizeMake(
                0,
                0
            )
        })
        
        //別スレッドで実行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //セットアップ
            self.setUp(list,indexies:indexies)
        })
        
        Log.debugEndLog()
    }
    
    func setUp (list: [Tack], indexies : [Int]) {
        Log.debugStartLog()

        //画像を配置する際のx座標
        var x : CGFloat = 0
        var y : CGFloat = 0
        
        //ScrollViewの左と上の隙間
        var leftPadding : CGFloat = 5.0
        var topPadding : CGFloat = 5.0
        
        //
        var scHeight : CGFloat = scView.frame.height
        var scWidth : CGFloat = scView.frame.width
        
        var count : CGFloat = 0
        var adjust : CGFloat = 0
        
        for tack in list {
            
            //画像があるならば。
            if(tack.hasFileFlg){
                
                if let image = HTTPLogic.getImage(tack.filePath) {
                    
                    var tackImage : TackImageView = TackImageView()
                    tackImage.tackId = tack.tackId
                    tackImage.contentMode = UIViewContentMode.ScaleAspectFit
                    var image: UIImage = HTTPLogic.getImage(tack.filePath)!
                    image = ImageLogic.resizeImageWidth50(image)
                    
                    //メインスレッドでUIの操作
                    dispatch_sync(dispatch_get_main_queue(),{
                        
                        tackImage.image = image
                        tackImage.frame = CGRectMake(
                        //x
                            leftPadding + count * 80 + adjust,
                        //y
                            topPadding,
                        //width
                            80,
                        //height
                            scHeight - topPadding * 2.0
                        );
                    
                        tackImage.layer.borderWidth = 2
                        tackImage.layer.borderColor = UIColor.whiteColor().CGColor
                        
                        //Viewに追加
                        self.scView.addSubview(tackImage)
                        tackImage.userInteractionEnabled = true
                        tackImage.lat = tack.lat
                        tackImage.lng = tack.lng
                        tackImage.delegate = self.parentController
                        
                        //クルクルを消す
                        MBProgressHUD.hideAllHUDsForView(self, animated: true)

                    })
                    
                    count++
                    //座標調整
                    adjust = 15 * count
                    
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.scView.contentSize = CGSizeMake(
                        leftPadding + count * 80 + adjust + leftPadding,
                        scHeight
                    )
                })
                
            }
        }
        
//        dispatch_async(dispatch_get_main_queue(),{
//            self.scView.contentSize = CGSizeMake(
//                leftPadding + count * 80 + adjust + leftPadding,
//                scHeight
//            )
//        })
//        
        
        Log.debugEndLog()
    }
    
    //近辺のTackリストがタップされたときの処理
    func toucheEvent(){
        
    }
    
}