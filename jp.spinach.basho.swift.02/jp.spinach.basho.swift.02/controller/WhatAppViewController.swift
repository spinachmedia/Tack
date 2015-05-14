
//
//  WhatAppViewController.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/04.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class WhatAppViewController: UIViewController {

    //LeftBoard
    @IBAction func openLeftBoard(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}
