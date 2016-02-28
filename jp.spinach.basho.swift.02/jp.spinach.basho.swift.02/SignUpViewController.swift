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
        
        //アクセストークンをローカルから取得
        let token : NSDictionary? = LocalDataLogic.getFBAccessTokenDictionary()
        
        if(token != nil){
            
            Log.debugLogWithTime("======アクセストークンを保持している======")
            
            //ローカルからアクセストークンを取得
            //アクセストークンをセット
            FBSDKAccessToken.setCurrentAccessToken(
                FBSDKAccessToken(
                    tokenString: token?.objectForKey("access_token") as! String!,
                    permissions: Array(arrayLiteral: token?.objectForKey("permissions") as! Set<NSObject>) as [AnyObject]!,
                    declinedPermissions:  Array(arrayLiteral: token?.objectForKey("declinedPermissions") as! Set<NSObject>) as [AnyObject]!,
                    appID: token?.objectForKey("appID") as! String!,
                    userID: token?.objectForKey("userID") as! String!,
                    expirationDate: token?.objectForKey("expiration_date") as! NSDate!,
                    refreshDate: token?.objectForKey("refreshDate") as! NSDate!
                )
            )
            
            //アクセストークンが有効か確認をする。
            Log.debugLogWithTime(FBSDKAccessToken.currentAccessToken().expirationDate);
            if(FBSDKAccessToken.currentAccessToken().expirationDate.compare(NSDate()) == NSComparisonResult.OrderedDescending){
                Log.debugLog("有効")
            }else{
                Log.debugLog("無効")
            }
            
            //名前の取得
            if(FBSDKProfile.currentProfile() != nil){
                LocalDataLogic.setSnsName( FBSDKProfile.currentProfile().name );
            }
            
            //自動でマップの画面に遷移
            toTopViewController()
            
        }else{
            
            //アクセストークンが無効
            Log.debugLogWithTime("======アクセストークンが空======")
            
            //表示のログインボタンからログインしてもらう
            
        }

    }
    
    
    @IBAction func login(sender: AnyObject) {
        let loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.Native
        
        loginManager.logInWithReadPermissions(
            ["public_profile","user_friends"] as [String],
            handler: {( result : FBSDKLoginManagerLoginResult!, error : NSError!) -> Void in

                if((error) != nil){
                    //エラー
                    print("login-error")
                }else if(result.isCancelled){
                    //キャンセルされたとき
                    print("login-cansel")
                }else{
                    
                    //他の画面に遷移してしまう？
                    print("login-ok")

                    FBSDKAccessToken.setCurrentAccessToken(result.token)
                    
                    let authData : NSDictionary = [
                        "access_token" : result.token.tokenString,
                        "permissions" : result.token.permissions,
                        "declinedPermissions" : result.token.declinedPermissions,
                        "appID" : result.token.appID,
                        "userID" : result.token.userID,
                        "expiration_date" : result.token.expirationDate,
                        "refreshDate" : result.token.refreshDate
                    ]
                    
                    LocalDataLogic.setFBAccessTokenDictionary(authData)
                    
                    LocalDataLogic.setSnsId(result.token.userID!)
                    
                    //名前の取得
                    if(FBSDKProfile.currentProfile() != nil){
                        LocalDataLogic.setSnsName( FBSDKProfile.currentProfile().name );
                    }
                    
                    self.toTopViewController()
                
                }
            }
        )
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    ///TOP画面に遷移する
    func toTopViewController (){
        
        SceneLogic.toMainViewController()

    }
}
