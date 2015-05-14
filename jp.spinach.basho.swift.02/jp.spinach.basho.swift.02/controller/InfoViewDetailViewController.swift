//
//  InfoViewDetailViewController.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/03/29.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class InfoViewDetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    //前画面から渡される値
    var tack : Tack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string: "")
        var request = NSURLRequest(URL: url!)
        self.webView?.loadRequest(request)
        
    }

}