
import UIKit
import CoreLocation

class MainViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,  UINavigationControllerDelegate  {
    
    var screenSize:CGSize? = UIScreen.mainScreen().applicationFrame.size

    @IBOutlet weak var uFoodCategoryButton: UIButton!
    @IBOutlet weak var uSceneCategoryButton: UIButton!
    @IBOutlet weak var uActivityCategoryButton: UIButton!
    @IBOutlet weak var uPlaceAutoButton: UIButton!
    
    /// 書き込み用画面
    @IBOutlet weak var tackWriteView: UIView!
    var operation : TackWriteView?
    
    var startFlg = true

    /// 座標のやつ
    var lm: CLLocationManager!

    
    var markerList: AnyObject!
    var tackedMarkerList : [GMSMarkerExt]?
    
    
    /// MAP
    @IBOutlet weak var mapView: GMSMapView!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        screenSize! = UIScreen.mainScreen().applicationFrame.size
        
        //投稿用のViewの座標情報を取得
        operation = UINib(nibName: "TackWriteView",
            bundle: nil)
            .instantiateWithOwner(self, options: nil)[0] as? TackWriteView
        self.tackWriteView.addSubview(operation!);
        operation!.setup()
        operation!.controller = self
        
        mapView.myLocationEnabled = true
        mapView.delegate = self
        
        lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestAlwaysAuthorization()
        lm.distanceFilter = 300
        lm.startUpdatingLocation()
        
        getHTTPAppiaries()
        
        
        
        self.tackWriteView.hidden = true
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        switch(state){
        case State.Nomal:
            toNomalState(0)
            break;
        case State.SelectingColor:
            toSelectColorState(0)
            break;
        case State.Operation:
            toOperateState(0)
            break;
        default:
            break;
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
    座標の取得を開始する
    */
    func startLocation(){
        lm.startUpdatingLocation()
    }
    
    func stopLocation(){
        
    }
    
    
    //座標の取得を開始する
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        //NSLog("bbb")
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:newLocation.coordinate.latitude,longitude:newLocation.coordinate.longitude)
        var now :GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(coordinate.latitude,longitude:coordinate.longitude,zoom:30)
        
        mapView.camera = now
        
    }
    
//MARK: - HTTPController

    /**
    HTTPリクエストを送信。
    ピンのリストを取得する
    */
    func getHTTPAppiaries(){
        
        //マネージャの生成
        let manager:AFHTTPRequestOperationManager = HTTPManager.HTTPRequestManagerFactory()
        
        manager.GET(Setting.GET_COMMENT_URL, parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                
                //レスポンス処理---------------------------------
                
                println("response: \(responseObject)")
                if(responseObject == nil){
                    
                }else{
                    self.markerList = responseObject
                }
                
                //ピンを消去する
                MapLogic.clearMarkers(self.mapView)
                
                //ピンを立てる。
                self.tackedMarkerList = MapLogic.setMarkers(self.markerList,mapView: self.mapView)
                
                //ズーム具合の調整--------------------------------
                
                //起動時のみ
                if(self.startFlg){
                    self.startFlg = false
                    var count = 0
                    //マーカーが５個以上見えていない場合
                    //ズームレベルが１５以上の場合
                    while(count < 5 && self.mapView.camera.zoom > 15){
                        count = 0
                        
                        self.mapView.moveCamera(GMSCameraUpdate.zoomOut())
                        println("into the roop.")
                        
                        //レスポンスがない場合は終了
                        if(self.markerList == nil){
                            return
                        }
                        //一件もない場合も処理しない
                        let markerJson = JSON(self.markerList)
                        let items = markerJson["_total"].stringValue.toInt()
                        if(items == 0){
                            return
                        }
                        
                        for ( var i = 0 ; i < items ;i++  ){
                            var marker : GMSMarkerExt = self.tackedMarkerList![i]
                            if(self.mapView.projection.containsCoordinate(marker.position)){
                                count++
                                println(count)
                            }//if
                        }//for
                    }//while
                }//if
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("error: \(error)")
            }
        )
    }
    
    /**
    ピンを指す。
    */
    func sendHTTPAppiaries(){
        
//        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.Indeterminate
//        loadingNotification.labelText = "Getting..."
//        
//        let img:UIImage? = self.tackWriteView.imageView.image
//        
//        var existImage = false
//        
//        if( img != nil ){
//            existImage = true
//        }else{
//        }
//        
//        let manager:AFHTTPRequestOperationManager = HTTPManager.HTTPRequestManagerFactory()
//        
//        //ObjectID生成
//        //画像とコメント情報との紐付けに利用する。
//        //FILEAPIではObjectIDとして登録
//        //重複時はどうしようか・・・
//        let uuid = Random.getObjectId();
//        
//        var commentParams: Dictionary = [
//            "object_id": uuid,
//            "user_id" : LocalDataLogic.getUUID(),
//            "has_image": existImage,
//            "category":     category.toString(),
//            "place":        self.uPlaceText.text,
//            "comment":      self.uCommentArea.text,
//            "lat":          NSString(format: "%.15f", self.lm.location.coordinate.latitude),
//            "lng":          NSString(format: "%.15f", self.lm.location.coordinate.longitude),
//            "id":           "1",
//            "tack_point":   0
//        ]
//        
//        manager.POST(Setting.SET_COMMENT_URL, parameters: commentParams,
//            success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
//                
//                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                self.getHTTPAppiaries()
//                
//            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
//                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                println("error: \(error)")
//                //TODO:容量オーバーの時の処理
//                //TODO:404の時の処理
//                //TODO:タイムアウトの時の処理
//                //TODO:その他エラーの時の処理
//        })
//        
//        //画像を送信
//        self.sendImage(uuid);
    }
    
    /**
    画像を送信する
    */
    func sendImage(objectId:String){
        
//        var manager : APISFileAPIClient = HTTPManager.getAppiariesSendFileManager()
//        
//        //画像の取り出し
//        let img:UIImage? = self.tackWriteView.imageView.image
//        if( img != nil ){
//            
//            //使いもしないメタデータ
//            var meta: Dictionary = [
//                "_tags": ""
//            ]
//            
//            //リサイズ
//            var imageData : NSData = ImageLogic.resizeIamgeWidth300(img);
//            
//            //送信
//            manager.createBinaryObjectWithId(objectId, filename: "image.jpeg", binary: imageData, meta: meta,
//                success: { (response : APISResponseObject!) in
//                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                    println(response)
//                }, failure: { (error : NSError!) in
//                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                    println(error)
//                    //TODO:容量オーバーの時の処理
//                    //TODO:404の時の処理
//                    //TODO:オブジェクトID重複時の処理
//                    //TODO:タイムアウトの時の処理
//                    //TODO:その他エラーの時の処理
//                }
//            )
//            
//        } else {
//            //nilの場合
//            println("nil");
//        }
        
    }
    
//MARK: - showToolTip Delegate
    

    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        println("tap!")
        
        let gmsMarker : GMSMarkerExt = marker as! GMSMarkerExt
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextController : InfoViewDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("InfoViewDetailViewController") as! InfoViewDetailViewController
        
        
        let json = JSON(self.markerList)
        
        nextController.objectId = json["_objs"][gmsMarker.id]["_id"].string!
        nextController.placeText = json["_objs"][gmsMarker.id]["place"].string!
        nextController.bodyText = json["_objs"][gmsMarker.id]["comment"].string!
        nextController.counter = json["_objs"][gmsMarker.id]["tack_point"].stringValue
        
        if(json["_objs"][gmsMarker.id]["has_image"].int! == 1){
            
            var imageUrl:String = "https://api-datastore.appiaries.com/v1/bin/_sandbox/Basho/image_latlang/" + json["_objs"][gmsMarker.id]["object_id"].string! + "/_bin"
            let url = NSURL(string: imageUrl)
            let imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
            let uiImage = UIImage(data: imageData!)
            nextController.image = uiImage
        }
        
        self.navigationController?.pushViewController(nextController as UIViewController, animated: true)
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let infoView:InfoView = UINib(nibName: "InfoView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! InfoView
        let gmsMarker : GMSMarkerExt = marker as! GMSMarkerExt
        
        let json = JSON(self.markerList)
        
        var imageUrl:String = "https://api-datastore.appiaries.com/v1/bin/_sandbox/Basho/image_latlang/" + json["_objs"][gmsMarker.id]["object_id"].string! + "/_bin"
        
        var imageFlg = false
        if(json["_objs"][gmsMarker.id]["has_image"].int! == 1){
            imageFlg = true
        }
            
        infoView.setViews(
            json["_objs"][gmsMarker.id]["place"].string!,
            body: json["_objs"][gmsMarker.id]["comment"].string!,
            imageUrl: imageUrl,
            imageFlg: imageFlg
        )
        
        return infoView
    }
    
//MARK: - buttonAction
    
    /// どの色でタックしますか？のView
    @IBOutlet weak var whichColorTackView: UIView!
    
    /// コメント入力のView
    //@IBOutlet weak var operationView: UIView!
    
    @IBOutlet weak var selectorButtons: UIView!
    
    var category = Category.FOOD
    
    @IBAction func tapWriteButton(sender: AnyObject) {
        switch(state){
            case State.Nomal:
                toSelectColorState(0.3)
                break;
            case State.SelectingColor:
                toNomalState(0.3)
                break;
            case State.Operation:
                toNomalState(0.3)
                break;
            default:
                break;
        }
        
    }

    @IBAction func selectFoodColor(sender: AnyObject) {
        category = Category.FOOD
        toOperateState(0.3)
    }
    @IBAction func selectSceneColor(sender: AnyObject) {
        category = Category.SCENE
        toOperateState(0.3)
    }
    @IBAction func selectActivityColor(sender: AnyObject) {
        category = Category.ACTIVITY
        toOperateState(0.3)
    }
    
    @IBAction func tackTweet(sender: AnyObject) {
        toNomalState(0.3)
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Sending"
        sendHTTPAppiaries()
    }
    
    //----------------------
    // 各カテゴリを絞るボタン
    //----------------------

    @IBOutlet weak var toggleCategoryFood: UIButton!
    @IBAction func toggleCategoryFood(sender: AnyObject) {
        if(self.toggleCategoryFood.alpha  == 1){
            self.toggleCategoryFood.alpha = 0.5
            MapLogic.filterCategory(self.tackedMarkerList!, category: Category.FOOD, map:self.mapView,showFlg: false)
        }else{
            self.toggleCategoryFood.alpha  = 1
            MapLogic.filterCategory(self.tackedMarkerList!, category: Category.FOOD, map:self.mapView,showFlg: true)
        }
        
    }
    
    @IBOutlet weak var toggleCategoryScene: UIButton!
    @IBAction func toggleCategoryScene(sender: AnyObject) {
        if(self.toggleCategoryScene.alpha  == 1){
            self.toggleCategoryScene.alpha = 0.5
            MapLogic.filterCategory(self.tackedMarkerList!, category: Category.SCENE, map:self.mapView,showFlg: false)
        }else{
            self.toggleCategoryScene.alpha  = 1
            MapLogic.filterCategory(self.tackedMarkerList!, category: Category.SCENE, map:self.mapView,showFlg: true)
        }
        
    }
    @IBOutlet weak var toggleCategoryActivity: UIButton!
    @IBAction func toggleCategoryActivity(sender: AnyObject) {
        if(self.toggleCategoryActivity.alpha  == 1){
            self.toggleCategoryActivity.alpha = 0.5
            MapLogic.filterCategory(self.tackedMarkerList!, category: Category.ACTIVITY, map:self.mapView,showFlg: false)
        }else{
            self.toggleCategoryActivity.alpha  = 1
            MapLogic.filterCategory(self.tackedMarkerList!, category: Category.ACTIVITY, map:self.mapView,showFlg: true)
        }
    }
    @IBOutlet weak var toggleCategoryMyTack: UIButton!
    @IBAction func toggleCategoryMyTack(sender: AnyObject) {
        if(self.toggleCategoryMyTack.alpha  == 1){
            self.toggleCategoryMyTack.alpha = 0.5
            MapLogic.filterCategory(self.tackedMarkerList!, category: Category.MYTACK, map:self.mapView,showFlg: false)
        }else{
            self.toggleCategoryMyTack.alpha  = 1
            MapLogic.filterCategory(self.tackedMarkerList!, category: Category.MYTACK, map:self.mapView,showFlg: true)
        }
    }
    
    

//MARK: - statusChaged
    
    var state = State.Nomal
    
    func toNomalState(num : NSTimeInterval){
        state = State.Nomal
        hideWhichColorTackView(num)
        showSelectorButtons(num)
        hideOperationView(num)
    }
    
    func toSelectColorState(num : NSTimeInterval){
        state = State.SelectingColor
        showWhichColorTackView(num)
        hideSelectorButtons(num)
        hideOperationView(num)
    }
    
    func toOperateState(num : NSTimeInterval){
        state = State.Operation
        hideWhichColorTackView(num)
        hideSelectorButtons(num)
        showOperationView(num)
    }
    
//MARK: - animationDefineDetails
    
    @IBOutlet weak var tackButton: UIButton!
    
    func showWhichColorTackView(num : NSTimeInterval){
        
        let objWidth = self.whichColorTackView.frame.size.width
        
        //initialize
        
        self.whichColorTackView.frame =
            CGRectMake(
                0,
                self.screenSize!.height,
                objWidth,
                0
        )
        
        UIView.animateWithDuration(num, animations: {() -> Void in
            self.tackButton.transform = CGAffineTransformMakeRotation(CGFloat(-179 * M_PI / 180.0))
            self.whichColorTackView.frame =
                CGRectMake(
                    0,
                    self.screenSize!.height / 1.7,
                    objWidth,
                    130
            )
            }, completion: {(Bool) -> Void in
                
        })
        
    }
    func hideWhichColorTackView(num : NSTimeInterval){
        
        let objWidth = self.whichColorTackView.frame.size.width
        
        UIView.animateWithDuration(num, animations: {() -> Void in
            
            self.tackButton.transform = CGAffineTransformMakeRotation(CGFloat(0 * M_PI / 180.0))
            
            self.whichColorTackView.frame =
            
            CGRectMake(
                0,
                self.screenSize!.height,
                objWidth,
                0
            )
            }, completion: {(Bool) -> Void in
                
        })
    }
    
//----------------
    
    func showSelectorButtons(num : NSTimeInterval){
        UIView.animateWithDuration(num, animations: {() -> Void in
            self.selectorButtons.frame =
                
                CGRectMake(
                    self.selectorButtons.frame.origin.x,
                    0,
                    self.selectorButtons.frame.size.width,
                    self.selectorButtons.frame.size.height
            )
            }, completion: {(Bool) -> Void in
                
        })
        
    }
    func hideSelectorButtons(num : NSTimeInterval){
        UIView.animateWithDuration(num, animations: {() -> Void in
            self.selectorButtons.frame =
                
                CGRectMake(
                    self.selectorButtons.frame.origin.x,
                    300,
                    self.selectorButtons.frame.size.width,
                    self.selectorButtons.frame.size.height
            )
            }, completion: {(Bool) -> Void in
                
        })
    }
    
//----------------
    ///ひとつまえのカテゴリを記憶・・・。なんだこのコード
    var beforeCategory: Category = Category.FOOD
    
    func showOperationView(num : NSTimeInterval){
        operation!.category = category
        self.tackWriteView.hidden = false
//        var time = num
//        if(category == beforeCategory){
//            //カテゴリに変更がなければ、なにもしない。
//            //カテゴリに変更がある場合はアニメーションを２度行う。
//            //・・・UIButtonの画像を変更するとUIViewAnimationがうまく動作しないので強引に対応。
//            //機種依存がでそうで嫌だなぁ・・・
//            //TODO 要確認
//        }else{
//            time = 0
//        }
        operation!.setColor({
            UIView.animateWithDuration(num,
                animations: {() -> Void in
                    self.tackWriteView.frame =
                        self.view.frame
                }, completion: {(Bool) -> Void in
//                    
//                    if(self.operation!.frame.height > 100){
//                        UIView.animateWithDuration(num,
//                            animations: {() -> Void in
//                                self.tackWriteView.frame =
//                                    self.view.frame
//                            }, completion: {(Bool) -> Void in
//                        })
//                    }
//                    self.beforeCategory = self.category
            })
        })
    }
    
    func hideOperationView(num : NSTimeInterval){
        UIView.animateWithDuration(num, animations: {() -> Void in
            self.tackWriteView.frame =
                CGRectMake(
                    0,
                    UIScreen.mainScreen().bounds.height,
                    UIScreen.mainScreen().bounds.width,
                    UIScreen.mainScreen().bounds.height
            )
            }, completion: {(Bool) -> Void in
                self.tackWriteView.hidden = true
        })
    }

    
    //LeftBoard
    @IBAction func openLeftBoard(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    /**
    Tackの更新
    
    :param: sender <#sender description#>
    */
    @IBAction func update(sender: AnyObject) {
        getHTTPAppiaries()
    }
    
    
    func checkFrame(){
        println(self.operation!.frame)
        println(self.tackWriteView.frame)
    }
}
