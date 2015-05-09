//
//  SignUpViewController.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/27.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController , FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        
        var token : FBSDKAccessToken? = FBSDKAccessToken.currentAccessToken()
        println(FBSDKAccessToken.currentAccessToken())
        
        var keyValues : NSMutableDictionary = NSMutableDictionary()
        keyValues.setObject("", forKey: "access_token")
        
        NSUserDefaults .standardUserDefaults().registerDefaults(keyValues as [NSObject : AnyObject])
        
        if(token != nil){
            //アクセストークンが有効
            println("OK!")
            toTopViewController()
        }else{
            //アクセストークンが無効
            println("NG!")
            
            //ローカルから取得
            var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var result : String? = defaults.stringForKey("access_token")
            
            if(result != ""){
                println("OK!")
                toTopViewController()
            }else{
                println("NG!")
            }
            
            
        }

    }
    
    
    @IBAction func login(sender: AnyObject) {
        
         println("login")
        
        var loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.Native
        
        loginManager.logInWithReadPermissions(
            ["public_profile","user_friends"] as [String],
            handler: {( result : FBSDKLoginManagerLoginResult!, error : NSError!) -> Void in
                
                println("logInWithReadPermissions")
                if((error) != nil){
                    //エラー
                    println("login-error")
                }else if(result.isCancelled){
                    //キャンセルされたとき
                    println("login-cansel")
                }else{
                    
                    //他の画面に遷移してしまう？
                    println("login-ok")

                    var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(result.token.tokenString, forKey: "access_token")
                    
                    FBSDKAccessToken.setCurrentAccessToken(result.token)
                    
                    //FBSDKProfile.currentProfile(FBSDKProfile(result.token))
                    
                    self.toTopViewController()
                
                }
            }
        )
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("loginButton")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    ///TOP画面に遷移する
    func toTopViewController (){
        
        SceneLogic.toMainViewController()

    }
}
