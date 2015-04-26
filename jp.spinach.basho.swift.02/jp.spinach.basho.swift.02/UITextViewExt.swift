//
//  UITextViewExt.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/26.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

public class UITextViewExt: UITextView {
    
    lazy var placeHolderLabel:UILabel = UILabel()
    var placeHolderColor:UIColor      = UIColor.lightGrayColor()
    var placeHolder:NSString          = ""
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    func setTextExt(text:NSString) {
        super.text = text as String
        self.textChanged(nil)
    }
    
    override public func drawRect(rect: CGRect) {
        if(self.placeHolder.length > 0) {
            self.placeHolderLabel.frame           = CGRectMake(8,8,self.bounds.size.width - 16,0)
            self.placeHolderLabel.lineBreakMode   = NSLineBreakMode.ByWordWrapping
            self.placeHolderLabel.numberOfLines   = 0
            self.placeHolderLabel.font            = self.font
            self.placeHolderLabel.backgroundColor = UIColor.clearColor()
            self.placeHolderLabel.textColor       = self.placeHolderColor
            self.placeHolderLabel.alpha           = 0
            self.placeHolderLabel.tag             = 999
            
            self.placeHolderLabel.text = self.placeHolder as String
            self.placeHolderLabel.sizeToFit()
            self.addSubview(placeHolderLabel)
        }
        
        self.sendSubviewToBack(placeHolderLabel)
        
        if(count(self.text.utf16) == 0 && self.placeHolder.length > 0){
            self.viewWithTag(999)?.alpha = 1
        }
        
        super.drawRect(rect)
    }
    
    public func textChanged(notification:NSNotification?) -> (Void) {
        if(self.placeHolder.length == 0){
            return
        }
        
        if(count(self.text) == 0) {
            self.viewWithTag(999)?.alpha = 1
        }else{
            self.viewWithTag(999)?.alpha = 0
        }
    }
    
}
