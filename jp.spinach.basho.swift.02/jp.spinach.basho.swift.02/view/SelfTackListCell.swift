//
//  SelfTackListCell.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/05.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class SelfTackListCell: UITableViewCell {

//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.FlexibleWidth
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var imagePicture: UIImageView!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var goodTackCount: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!
    
    
}
