//
//  InfoViewDetailViewController.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/29.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class InfoViewDetailViewController: UIViewController , UIWebViewDelegate{

    
    @IBOutlet weak var webView: UIWebView!
    
    //前画面から渡される値
    var tack : Tack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = NSBundle.mainBundle().pathForResource(Setting.LOCAL_HTML_TACKDETAIL, ofType: "html");
        let requestURL = NSURL(string: urlString!)
        let req = NSURLRequest(URL: requestURL!)
        self.webView.loadRequest(req)
        self.webView.delegate = self
        self.webView.scrollView.bounces = false
        
        //ロード中を示す
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // 色を変数に用意しておく
        let color = UIColor(red: 255/255, green: 158/255, blue: 35/255, alpha: 1.0)
        
        // 背景の色を変えたい。
        self.navigationController?.navigationBar.barTintColor = color

    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //パラメータをセットする
        setParamater()
        //リプライの取得をWebViewにさせる。
        setReply()
        //読み込みを完了させる。
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func setParamater(){
        
        //GET先のURLをHTMLに渡す
        let urlSetDomeinMethod = "setDomain('http://tack.spinachmedia.info:3000/')";
        webView.stringByEvaluatingJavaScriptFromString(urlSetDomeinMethod)
        
        let urlSetMethod = "setUrlGetList('http://tack.spinachmedia.info:3000/api/getReply');"
        webView.stringByEvaluatingJavaScriptFromString(urlSetMethod)
        
        let urlSendReply = "setUrlSendReply('http://tack.spinachmedia.info:3000/api/postReply');"
        webView.stringByEvaluatingJavaScriptFromString(urlSendReply)
        
        let urlGoodTack = "setUrlGoodTack('http://tack.spinachmedia.info:3000/api/postGood');"
        webView.stringByEvaluatingJavaScriptFromString(urlGoodTack)
        
        let setOwnerSnsId = "setOwnerSnsId(" + FBSDKProfile.currentProfile().userID! + ");"
        webView.stringByEvaluatingJavaScriptFromString( setOwnerSnsId )
        
        let setOwnerSnsToken = "setOwnerToken('" + SNSLogic.getSNSToken() + "');"
        webView.stringByEvaluatingJavaScriptFromString( setOwnerSnsToken )
        
        let setTackId = "setTackId('" + tack!.tackId + "');";
        webView.stringByEvaluatingJavaScriptFromString( setTackId )
        
        let setSnsId = "setSnsId('" + tack!.snsId + "');";
        webView.stringByEvaluatingJavaScriptFromString( setSnsId )
        
        let setSnsName = "setSnsName('" + tack!.snsName + "');";
        webView.stringByEvaluatingJavaScriptFromString( setSnsName )
        
        
        let setImage = "setImage('https://graph.facebook.com/" + tack!.snsId + "/picture');";
        webView.stringByEvaluatingJavaScriptFromString( setImage )
        
        let setSnsCategory = "setSnsCategory('" + tack!.snsCategory + "');";
        webView.stringByEvaluatingJavaScriptFromString( setSnsCategory )
        
        let setCategory = "setCategory('" + tack!.category.toString() + "');";
        webView.stringByEvaluatingJavaScriptFromString( setCategory )
        
        let setPlaceName = "setPlaceName('" + tack!.placeName + "');";
        webView.stringByEvaluatingJavaScriptFromString( setPlaceName )
        
        let setComment = "setComment('" + tack!.comment + "');";
        webView.stringByEvaluatingJavaScriptFromString( setComment )
        
        let setGoodTack = "setGoodTack('" + String(tack!.goodTackCount) + "');";
        webView.stringByEvaluatingJavaScriptFromString( setGoodTack )
        
        let setCityCode = "setCityCode('" + tack!.cityCode + "');";
        webView.stringByEvaluatingJavaScriptFromString( setCityCode )
        
        let setLat = "setLat('" +  String(stringInterpolationSegment: tack!.lat) + "');";
        webView.stringByEvaluatingJavaScriptFromString( setLat )
        
        let setLng = "setLng('" + String(stringInterpolationSegment: tack!.lng) + "');";
        webView.stringByEvaluatingJavaScriptFromString( setLng )
        
        var setHasFileFlg = ""
        if(tack!.hasFileFlg){
            setHasFileFlg = "setHasFileFlg(true);";
        }else{
            setHasFileFlg = "setHasFileFlg(false);";
        }
        webView.stringByEvaluatingJavaScriptFromString( setHasFileFlg )
        
        let setFilePath = "setFilePath('http://tack.spinachmedia.info:3000/" + tack!.filePath + "');";
        webView.stringByEvaluatingJavaScriptFromString( setFilePath )
        
        let setDate = "setDate('" + DateLogic.date2StringForView(tack!.date) + "');";
        webView.stringByEvaluatingJavaScriptFromString( setDate )
        
    }
    
    //WEBViewに対してリプライのリストを取得するように仕向ける
    func setReply(){
        let getReplayList = "getReplyList();"
        webView.stringByEvaluatingJavaScriptFromString( getReplayList )
    }
    
    //WEBViewからのネイティブへの連携
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
            default:
                break;
            }
            return false  // ページ遷移を行わないようにfalseを返す
        }
        return true
    }


}