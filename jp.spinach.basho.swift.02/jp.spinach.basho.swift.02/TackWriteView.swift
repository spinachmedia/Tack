//
//  TackWriteView.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/21.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIKit

class TackWriteView: UIView ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var back: UIView!
    
    //座標情報
    var lm: CLLocationManager!
    
    
    var colorTheme : UIColor?
    var startColor : UIColor?
    var endColor : UIColor?
    var bgColor : UIColor?
    
    var alphaColor : UIColor? = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    
    var controller : MainViewController?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var placeAreaView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    
    //入力項目
    var category : Category = Category.FOOD
    @IBOutlet weak var placeText: UITextField!
    @IBOutlet weak var textView: UITextViewExt!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var removeButton: UIButton!
    
    //色を変えるボタン
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var gallaryButton: UIButton!
    @IBOutlet weak var tackButton: UIButton!
    
    var food_tack_button : UIImage?
    var food_camera_button : UIImage?
    var food_picture_button : UIImage?
    
    var scene_tack_button : UIImage?
    var scene_camera_button : UIImage?
    var scene_picture_button : UIImage?
    
    var activity_tack_button : UIImage?
    var activity_camera_button : UIImage?
    var activity_picture_button : UIImage?
    
    
    

    
    func setColor(callback : () -> Void){
        switch(category){
        case Category.FOOD:
            
            self.colorTheme = UIColor(red: 240/255, green: 180/255, blue: 210/255, alpha: 1)
            startColor = UIColor(red: 240/255, green: 180/255, blue: 210/255, alpha: 0.4)
            endColor = UIColor(red: 240/255, green: 180/255, blue: 210/255, alpha: 0.6)
            bgColor = UIColor(red: 240/255, green: 180/255, blue: 210/255, alpha: 0.4)
            
            self.cameraButton.setImage(food_camera_button, forState: UIControlState.Normal)
            self.gallaryButton.setImage(food_picture_button, forState: UIControlState.Normal)
            self.tackButton.setImage(food_tack_button, forState: UIControlState.Normal)
            
            break;
        case Category.SCENE:
            self.colorTheme = UIColor(red: 121/255, green: 198/255, blue: 231/255, alpha: 1)
            startColor = UIColor(red: 121/255, green: 198/255, blue: 231/255, alpha: 0.4)
            endColor = UIColor(red: 81/255, green: 181/255, blue: 223/255, alpha: 0.4)
            bgColor = UIColor(red: 121/255, green: 198/255, blue: 231/255, alpha: 0.4)
            self.cameraButton.setImage(scene_camera_button, forState: UIControlState.Normal)
            self.gallaryButton.setImage(scene_picture_button, forState: UIControlState.Normal)
            self.tackButton.setImage(scene_tack_button, forState: UIControlState.Normal)
            break;
        case Category.ACTIVITY:
            self.colorTheme = UIColor(red: 231/255, green: 209/255, blue: 109/255, alpha: 1)
            startColor = UIColor(red: 231/255, green: 209/255, blue: 109/255, alpha: 0.4)
            endColor = UIColor(red: 223/255, green: 192/255, blue: 49/255, alpha: 0.4)
            bgColor = UIColor(red: 231/255, green: 209/255, blue: 109/255, alpha: 0.4)
            self.cameraButton.setImage(activity_camera_button, forState: UIControlState.Normal)
            self.gallaryButton.setImage(activity_picture_button, forState: UIControlState.Normal)
            self.tackButton.setImage(activity_tack_button, forState: UIControlState.Normal)
            
            break;
        default:
            break;
        }
        
//        var grad : CAGradientLayer = CAGradientLayer()
//        grad.frame = self.bounds
//        grad.colors = [self.startColor!.CGColor,self.endColor!.CGColor]
//        
//        self.back.layer.sublayers = nil
//        self.back.layer.insertSublayer(grad, atIndex: 0)
        
        self.back.backgroundColor = alphaColor!
        
        self.footerView.layer.borderColor = self.colorTheme!.CGColor
        self.footerView.layer.borderWidth = 1
        
        self.placeAreaView.layer.borderColor = self.colorTheme!.CGColor
        self.placeAreaView.layer.borderWidth = 1
        
        self.frameView.layer.borderColor = self.colorTheme!.CGColor
        self.frameView.layer.borderWidth = 1
        
        if(self.imageView.image != nil){
            self.imageView.backgroundColor = self.bgColor
        }
        
        
        callback()
        
        var grad : CAGradientLayer = CAGradientLayer()
        grad.frame = self.bounds
        grad.colors = [self.startColor!.CGColor,self.endColor!.CGColor]
        
        self.back.layer.sublayers = nil
        self.back.layer.insertSublayer(grad, atIndex: 0)
    }
    
    func setup(){
        
        food_tack_button = UIImage(named: "button01_food.png")!
        food_camera_button = UIImage(named: "button01_camera_food.png")!
        food_picture_button = UIImage(named: "button01_picture_food.png")!
        
        scene_tack_button = UIImage(named: "button02_shopping.png")!
        scene_camera_button = UIImage(named: "button02_camera_shopping.png")!
        scene_picture_button = UIImage(named: "button02_picture_shopping.png")!
        
        activity_tack_button = UIImage(named: "button03_activity.png")!
        activity_camera_button = UIImage(named: "button03_camera_activity.png")!
        activity_picture_button = UIImage(named: "button03_picture_activity.png")!
        
        setColor({})
        
        self.textView.placeHolder = "この場所にコメントを残してください"
        self.textView.placeHolderColor = UIColor.lightGrayColor()
        
        var gesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap")
        self.addGestureRecognizer(gesture)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardUp:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    //画面領域のタップでキーボードを隠す
    func tap(){
        self.endEditing(true)
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.frame = CGRectMake(0,
                0,
                UIScreen.mainScreen().bounds.width,
                UIScreen.mainScreen().bounds.height
            )
            }, completion: {(Bool) -> Void in
        })
    }
    
    ///キーボードがでてきたときの処理
    func keyboardUp(notification : NSNotification){
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.frame = CGRectMake(0,
                -self.placeAreaView.frame.height + 5,
                UIScreen.mainScreen().bounds.width,
                UIScreen.mainScreen().bounds.height
            )
        }, completion: {(Bool) -> Void in
        })
    }
    
    
    
    @IBAction func goCamera(sender: AnyObject) {
        pickImageFromCamera()
    }
    
    @IBAction func goGallary(sender: AnyObject) {
        pickImageFromLibrary()
    }
    
    
    
    
    //MARK: - Picture Selector
    
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let con = UIImagePickerController()
            con.delegate = self
            con.sourceType = UIImagePickerControllerSourceType.Camera
            self.controller!.presentViewController(con, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let con = UIImagePickerController()
            con.delegate = self
            con.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.controller!.presentViewController(con, animated: true, completion: nil)
        }
    }
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            println(image)
            self.imageView.image = image
            self.imageView.backgroundColor = self.bgColor
            self.removeButton.hidden = false
        }
        picker.dismissViewControllerAnimated(true, completion: {
        })
    }
    
    ///添付した画像を削除する
    @IBAction func removePicture(sender: AnyObject) {
        rmPic()
    }
    
    func rmPic(){
        self.removeButton.hidden = true
        var frameBk = self.imageView.frame
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.imageView.frame = CGRect(
                x: self.imageView.frame.origin.x +
                    self.imageView.frame.width / 2 ,
                y: self.imageView.frame.origin.y +
                    self.imageView.frame.height / 2 ,
                width: 0,
                height: 0
            )
            }, completion: {(Bool) -> Void in
                self.imageView.image = nil
                self.imageView.frame = frameBk
                self.imageView.backgroundColor = UIColor.whiteColor()
        })
    }
    
    
    //SEND!!!!!!!
    
    @IBAction func sendTack(sender: AnyObject) {
        var imageData : NSData!;
        if(imageView.image != nil){
            imageData = ImageLogic.resizeIamgeWidth300(imageView.image)
        }else{
            imageData = nil;
        }
            
            HTTPLogic.postTackRequest(
                FBSDKProfile.currentProfile().userID,
                category: category,
                placeName: placeText.text,
                comment: textView.text,
                lat: self.lm.location.coordinate.latitude,
                lng: self.lm.location.coordinate.longitude,
                fileData: imageData,
                callBack:{ (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                    println(responseObject)
                    
                    self.placeText.text = ""
                    self.textView.text = ""
                    self.rmPic()
                    
                    self.controller?.close()
                    
                }
            )
    }
    
    //グラデーションアニメ
    func startAnimation(){
        
//        UIView.animateWithDuration(1.0, animations: {() -> Void in
//            
//            var grad : CAGradientLayer = CAGradientLayer()
//            grad.frame = self.bounds
//            grad.colors = [self.startColor!.CGColor,self.endColor!.CGColor]
//            
//            self.back.layer.sublayers = nil
//            self.back.layer.insertSublayer(grad, atIndex: 0)
//            
//            }, completion: {(Bool) -> Void in
//        })

    }
    
}
