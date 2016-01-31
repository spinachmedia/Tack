//
//  LeftboardViewController.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/04.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class LeftboardViewController: UIViewController {
    
    var homeviewController : UINavigationController?

    @IBAction func toHome(sender: AnyObject) {
        
//        self.slideMenuController()?.mainViewController = homeviewController
//        
        //次の画面を生成
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let centerViewController : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
        
        self.slideMenuController()?.mainViewController = centerViewController

        
        //スライドを閉じる
        self.slideMenuController()?.closeLeft()
    }
    @IBAction func toTackList(sender: AnyObject) {
        //次の画面を生成
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController : TackListViewController = storyBoard.instantiateViewControllerWithIdentifier("TackListViewController") as! TackListViewController
        
        //        ( self.slideMenuController()?.mainViewController? as UINavigationController ).pushViewController(nextViewController, animated: true)
        
        self.slideMenuController()?.mainViewController = nextViewController
        
        //スライドを閉じる
        self.slideMenuController()?.closeLeft()
    }
    @IBAction func toRegisterAcount(sender: AnyObject) {
        
        //次の画面を生成
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController : RegisterAcountViewController = storyBoard.instantiateViewControllerWithIdentifier("RegisterAcountViewController") as! RegisterAcountViewController
        
    //        ( self.slideMenuController()?.mainViewController? as UINavigationController ).pushViewController(nextViewController, animated: true)
        
        self.slideMenuController()?.mainViewController = nextViewController
        
        //スライドを閉じる
        self.slideMenuController()?.closeLeft()

    }
    @IBAction func toEditSetting(sender: AnyObject) {
        
        //次の画面を生成
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController : EditSettingViewController = storyBoard.instantiateViewControllerWithIdentifier("EditSettingViewController") as! EditSettingViewController
        
        //( self.slideMenuController()?.mainViewController? as UINavigationController ).pushViewController(nextViewController, animated: true)
        self.slideMenuController()?.mainViewController = nextViewController
        
        //スライドを閉じる
        self.slideMenuController()?.closeLeft()
        
    }
    
    @IBAction func toWhatApps(sender: AnyObject) {
        
        //次の画面を生成
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController : WhatAppViewController = storyBoard.instantiateViewControllerWithIdentifier("WhatAppViewController") as! WhatAppViewController
        
        self.slideMenuController()?.mainViewController = nextViewController
        
        //スライドを閉じる
        self.slideMenuController()?.closeLeft()
        
    }
    
    //アカウント情報の表示
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //名前の取得
        if(FBSDKProfile.currentProfile() != nil){
            
            userName.text = FBSDKProfile.currentProfile().name
            
            //画像の取得
            let pictureView = FBSDKProfilePictureView()
            
            pictureView.profileID = FBSDKProfile.currentProfile().userID
            pictureView.pictureMode = FBSDKProfilePictureMode.Square
            
            pictureView.frame = CGRectMake(0,0,userImageView.frame.width,userImageView.frame.height)
            
            userImageView.addSubview(pictureView)

        }
        
    }
    
    
    @IBAction func logoutButton(sender: AnyObject) {
        
        let loginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject("", forKey: "access_token")
        
        loginManager.loginBehavior = FBSDKLoginBehavior.SystemAccount
        
        loginManager.logOut()
        
        SceneLogic.toSignInViewController()
        
    }
    
}
