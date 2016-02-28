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
    
    
    var tackList : [Tack]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = NSBundle.mainBundle().pathForResource(Setting.LOCAL_HTML_TACKLIST, ofType: "html");
        let requestURL = NSURL(string: urlString!)
        let req = NSURLRequest(URL: requestURL!)
        self.webView.loadRequest(req)
        self.webView.delegate = self
        self.webView.scrollView.bounces = false
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        HTTPLogic.getMyTack { (operation, responseObject) -> Void in
            self.tackList = Tack.tackListFactory(responseObject)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        getMyTackList("FB");
    }
    
    func getMyTackList(sns:String){
        
        //GET先のURLをHTMLに渡す
        let urlSetDomeinMethod = "setDomain('http://tack.spinachmedia.info:3000/')";
        webView.stringByEvaluatingJavaScriptFromString(urlSetDomeinMethod)
        
        let urlSetBgImage = "setUrlGetBgImage('http://tack.spinachmedia.info:3000/api/getLastImage');"
        webView.stringByEvaluatingJavaScriptFromString(urlSetBgImage)
        
        let urlSetMethod = "setUrlGetList('http://tack.spinachmedia.info:3000/api/getMyTack');"
        webView.stringByEvaluatingJavaScriptFromString(urlSetMethod)
        
        let token = "setSNSToken('" + SNSLogic.getSNSToken() + "');"
        webView.stringByEvaluatingJavaScriptFromString(token)
        
        switch(sns){
            case "FB":

                let snsIdSetMethod = "setSNSID('" + FBSDKProfile.currentProfile().userID + "');"
                webView.stringByEvaluatingJavaScriptFromString(snsIdSetMethod)
                
                let snsTypeSetMethod = "setSNSType('" + sns + "');"
                webView.stringByEvaluatingJavaScriptFromString(snsTypeSetMethod)
                
                let snsNameSetMethod = "setName('" + FBSDKProfile.currentProfile().name + "');"
                webView.stringByEvaluatingJavaScriptFromString(snsNameSetMethod)
                
                let snsImageSetMethod = "setImage('" +
                    "https://graph.facebook.com/" +
                    FBSDKProfile.currentProfile().imagePathForPictureMode(
                        FBSDKProfilePictureMode.Normal,
                        size: CGSizeMake(100,100)
                    ) +
                "');"
                webView.stringByEvaluatingJavaScriptFromString( snsImageSetMethod )
                
                let snsGetTack = "getTackList();"
                webView.stringByEvaluatingJavaScriptFromString( snsGetTack )
                
                let getBgImage = "getBgImage();"
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
        print(url);
        
        if url.hasPrefix(kScheme) {
            print(request.URL!.host!);
            switch request.URL!.host! {
                case "loadFinished":
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    return false;
                case "toDetail":
                    
                    //まだTackリストを取得できていない場合
                    if let a = self.tackList {
                        
                    }else{
                        return false;
                    }
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController : InfoViewDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("InfoViewDetailViewController") as! InfoViewDetailViewController

                    for tack in self.tackList! {
                        if tack.tackId == request.URL!.lastPathComponent {
                            nextController.tack = tack
                        }else{
                            
                        }
                    }
                    
                    self.navigationController?.pushViewController(nextController as UIViewController, animated: true)
                    
                    return false;
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
