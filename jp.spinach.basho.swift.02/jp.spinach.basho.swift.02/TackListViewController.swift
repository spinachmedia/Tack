//
//  TackListViewController.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/04.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class TackListViewController: UIViewController , UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = NSBundle.mainBundle().pathForResource(Setting.LOCAL_HTML_TACKLIST, ofType: "html");
        let requestURL = NSURL(string: urlString!)
        let req = NSURLRequest(URL: requestURL!)
        self.webView.loadRequest(req)
        self.webView.delegate = self
        self.webView.scrollView.bounces = false
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        getMyTackList("FB");
    }
    
    func getMyTackList(sns:String){
        
        //GET先のURLをHTMLに渡す
        var urlSetDomeinMethod = "setDomain('http://tack.spinachmedia.info:3000/')";
        webView.stringByEvaluatingJavaScriptFromString(urlSetDomeinMethod)
        
        var urlSetBgImage = "setUrlGetBgImage('http://tack.spinachmedia.info:3000/api/getLastImage');"
        webView.stringByEvaluatingJavaScriptFromString(urlSetBgImage)
        
        var urlSetMethod = "setUrlGetList('http://tack.spinachmedia.info:3000/api/getMyTack');"
        webView.stringByEvaluatingJavaScriptFromString(urlSetMethod)
        
        switch(sns){
            case "FB":

                var snsIdSetMethod = "setSNSID('" + FBSDKProfile.currentProfile().userID + "');"
                webView.stringByEvaluatingJavaScriptFromString(snsIdSetMethod)
                
                println(FBSDKProfile.currentProfile().userID)
                
                var snsTypeSetMethod = "setSNSType('" + sns + "');"
                webView.stringByEvaluatingJavaScriptFromString(snsTypeSetMethod)
                
                var snsNameSetMethod = "setName('" + FBSDKProfile.currentProfile().name + "');"
                webView.stringByEvaluatingJavaScriptFromString(snsNameSetMethod)
                
                var snsImageSetMethod = "setImage('" +
                    "https://graph.facebook.com/" +
                    FBSDKProfile.currentProfile().imagePathForPictureMode(
                        FBSDKProfilePictureMode.Normal,
                        size: CGSizeMake(100,100)
                    ) +
                "');"
                webView.stringByEvaluatingJavaScriptFromString( snsImageSetMethod )
                
                var snsGetTack = "getTackList();"
                webView.stringByEvaluatingJavaScriptFromString( snsGetTack )
                
                var getBgImage = "getBgImage();"
                webView.stringByEvaluatingJavaScriptFromString( getBgImage )

                
                break;
            case "TWITTER":
                break;
            default:
                break;
        }
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let kScheme = "native://";
        let url = request.URL!.absoluteString
        println(url!);
        
        if url!.hasPrefix(kScheme) {
            println(request.URL!.host!);
            switch request.URL!.host! {
                case "loadFinished":
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    return false;
                    break;
                case "toDetail":
                    return false;
                    break;
                default:
                break;
            }
            return false  // ページ遷移を行わないようにfalseを返す
        }
        return true
    }
    
    //LeftBoard
    @IBAction func openLeftBoard(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}
