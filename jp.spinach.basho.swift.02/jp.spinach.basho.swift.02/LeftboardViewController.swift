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
        
        self.slideMenuController()?.mainViewController = homeviewController
        
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
        
        //( self.slideMenuController()?.mainViewController? as UINavigationController ).pushViewController(nextViewController, animated: true)
        self.slideMenuController()?.mainViewController = nextViewController
        
        //スライドを閉じる
        self.slideMenuController()?.closeLeft()
        
    }
}
