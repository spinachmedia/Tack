//
//  SceneLogic.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/05/02.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import Foundation


struct SceneLogic {
    
    static func toMainViewController(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let centerViewController : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
        let leftViewController : LeftboardViewController = storyBoard.instantiateViewControllerWithIdentifier("LeftboardViewController") as! LeftboardViewController
        leftViewController.homeviewController = centerViewController
        let slideMenuController = SlideMenuController(mainViewController: centerViewController, leftMenuViewController: leftViewController)
        (UIApplication.sharedApplication().delegate as! AppDelegate ).window?.rootViewController = slideMenuController
    }
    
    static func toSignInViewController(){
        //left slide manu setup
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let centerViewController : SignUpViewController = storyBoard.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        (UIApplication.sharedApplication().delegate as! AppDelegate ).window?.rootViewController = centerViewController
    }
}