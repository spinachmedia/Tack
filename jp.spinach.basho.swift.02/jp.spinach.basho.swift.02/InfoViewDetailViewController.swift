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

    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //パラメータをセットする
        setParamater()
        //リプライの取得をWebViewにさせる。
        setReply()
    }
    
    func setParamater(){
        
        //GET先のURLをHTMLに渡す
        var urlSetDomeinMethod = "setDomain('http://tack.spinachmedia.info:3000/')";
        webView.stringByEvaluatingJavaScriptFromString(urlSetDomeinMethod)
        
        var urlSetMethod = "setUrlGetList('http://tack.spinachmedia.info:3000/api/getReply');"
        webView.stringByEvaluatingJavaScriptFromString(urlSetMethod)
        
        var urlSendReply = "setUrlSendReply('http://tack.spinachmedia.info:3000/api/postReply');"
        webView.stringByEvaluatingJavaScriptFromString(urlSendReply)
        
        var setTackId = "setTackId('" + tack!.tackId + "');";
        webView.stringByEvaluatingJavaScriptFromString( setTackId )
        
        var setSnsId = "setSnsId('" + tack!.snsId + "');";
        webView.stringByEvaluatingJavaScriptFromString( setSnsId )
        
        var setSnsName = "setSnsName('" + tack!.snsName + "');";
        webView.stringByEvaluatingJavaScriptFromString( setSnsName )
        
//        var setSnsImage = "setSnsImage('" +  + "');";
//        webView.stringByEvaluatingJavaScriptFromString( setSnsImage )
        
        var setSnsCategory = "setSnsCategory('" + tack!.snsCategory + "');";
        webView.stringByEvaluatingJavaScriptFromString( setSnsCategory )
        
        var setCategory = "setCategory('" + tack!.category.toString() + "');";
        webView.stringByEvaluatingJavaScriptFromString( setCategory )
        
        var setPlaceName = "setPlaceName('" + tack!.placeName + "');";
        webView.stringByEvaluatingJavaScriptFromString( setPlaceName )
        
        var setComment = "setComment('" + tack!.comment + "');";
        webView.stringByEvaluatingJavaScriptFromString( setComment )
        
        var setGoodTack = "setGoodTack('" + String(tack!.goodTackCount) + "');";
        webView.stringByEvaluatingJavaScriptFromString( setGoodTack )
        
        var setCityCode = "setCityCode('" + tack!.cityCode + "');";
        webView.stringByEvaluatingJavaScriptFromString( setCityCode )
        
        var setLat = "setLat('" +  String(stringInterpolationSegment: tack!.lat) + "');";
        webView.stringByEvaluatingJavaScriptFromString( setLat )
        
        var setLng = "setLng('" + String(stringInterpolationSegment: tack!.lng) + "');";
        webView.stringByEvaluatingJavaScriptFromString( setLng )
        
        var setHasFileFlg = ""
        if(tack!.hasFileFlg){
            setHasFileFlg = "setHasFileFlg(true);";
        }else{
            setHasFileFlg = "setHasFileFlg(false);";
        }
        webView.stringByEvaluatingJavaScriptFromString( setHasFileFlg )
        
        var setFilePath = "setFilePath('" + tack!.filePath + "');";
        webView.stringByEvaluatingJavaScriptFromString( setFilePath )
        
        var setDate = "setDate('" + DateLogic.date2String(tack!.date) + "');";
        webView.stringByEvaluatingJavaScriptFromString( setDate )
        
    }
    
    //WEBViewに対してリプライのリストを取得するように仕向ける
    func setReply(){
        var getReplayList = "getReplyList();"
        webView.stringByEvaluatingJavaScriptFromString( getReplayList )
    }
    
    //WEBViewからのネイティブへの連携
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
            default:
                break;
            }
            return false  // ページ遷移を行わないようにfalseを返す
        }
        return true
    }


}