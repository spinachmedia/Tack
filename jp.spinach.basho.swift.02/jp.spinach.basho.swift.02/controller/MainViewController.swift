
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

    //消したい
    var markerList: AnyObject!
    var tackedMarkerList : [GMSMarkerExt]?
    
    
    /// MAP
    @IBOutlet weak var mapView: GMSMapView!
    
    
    //受信したtackのリストを格納するリスト
    var tackList : [Tack]?
    
    
    

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
        
        
        //座標を取得する感じにする
        lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.requestAlwaysAuthorization()
        lm.distanceFilter = 300
        lm.startUpdatingLocation()
        

        
        //
        self.tackWriteView.hidden = true
        
        
        self.getTack();
        
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
    func getTack(){
        
        
        //非同期通信とコールバックの設定
        HTTPLogic.getTackRequest("test",
            lat: self.lm.location.coordinate.latitude,
            lng: self.lm.location.coordinate.longitude,
            count: 30,
            callBack:
            { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                
                    //レスポンス処理---------------------------------
                    println("response: \(responseObject)")
                    if(responseObject == nil){
                        return
                    }else{
                        //Tackインスタンスのリストに変換して保持しておく
                        self.tackList = Tack.tackListFactory(responseObject)
                    }
    
                    //ピンを消去する。ピンを立てる。
                    MapLogic.clearMarkers(self.mapView)
                    self.tackedMarkerList = MapLogic.setMarkers(self.tackList!,mapView: self.mapView)
    
                    //アプリの起動時のみ、ズーム具合の調整
                    if(self.startFlg){
                        self.startFlg = false
                        MapLogic.ajustZoomPoint(self.tackedMarkerList!, mapView: self.mapView)
                    }
                }
        )
        
    }
    
//MARK: - showToolTip Delegate
    
    //InfoWindowをタップした場合の処理。
    //tackの詳細画面に飛びます
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        println("tap!")
        
        let gmsMarker : GMSMarkerExt = marker as! GMSMarkerExt
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextController : InfoViewDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("InfoViewDetailViewController") as! InfoViewDetailViewController
        nextController.tack = self.tackList![gmsMarker.id]
        self.navigationController?.pushViewController(nextController as UIViewController, animated: true)
    }
    
    //InfoWindowを表示するときの処理
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let infoView:InfoView = UINib(nibName: "InfoView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! InfoView
        let gmsMarker : GMSMarkerExt = marker as! GMSMarkerExt
        
        //ピンをでかくする
        //gmsMarker.icon = ImageLogic.resizeImageWidth80(UIImage(named: "pin02_shopping"))
        
        infoView.initialize(self.tackList![gmsMarker.id])
        return infoView
    }
    
    
    
    //-------------------
    //-------------------
    // 以下、主にアニメーションの制御
    //-------------------
    //-------------------
    
//MARK: - buttonAction
    
    /// どの色でタックしますか？のView
    @IBOutlet weak var whichColorTackView: UIView!
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
                    0 - 5,
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
    
    ///画面下部のボタン群
    @IBOutlet weak var footerView: UIView!
    
    func showOperationView(num : NSTimeInterval){
        
        operation!.category = category
        self.tackWriteView.hidden = false
//        self.tackButton.setBackgroundImage(
//            UIImage(named:"icon00_tack_back.png"),
//            forState: UIControlState.Normal)

        self.view.bringSubviewToFront(self.footerView)
        
        //座標データを渡す
        operation!.lm = self.lm
        
        operation!.setColor({
            UIView.animateWithDuration(num,
                animations: {() -> Void in
                    self.tackWriteView.frame =
                        self.view.frame
                }, completion: {(Bool) -> Void in
                    self.view.bringSubviewToFront(self.footerView)
                    self.operation!.startAnimation()
            })
        })
    }
    
    func hideOperationView(num : NSTimeInterval){
//        self.tackButton.setBackgroundImage(
//            UIImage(named:"icon00_tack.png"),
//            forState: UIControlState.Normal)
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
    
//---------
    

    
    //LeftBoard
    @IBAction func openLeftBoard(sender: AnyObject) {
        //println(FBSDKAccessToken.currentAccessToken())
        self.slideMenuController()?.openLeft()
    }
    /**
    Tackの更新
    
    :param: sender <#sender description#>
    */
    @IBAction func update(sender: AnyObject) {
        
    }
    
    
    func checkFrame(){
        println(self.operation!.frame)
        println(self.tackWriteView.frame)
    }
}

