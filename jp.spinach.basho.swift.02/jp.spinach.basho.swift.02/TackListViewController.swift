//
//  TackListViewController.swift
//  jp.spinach.basho.swift.02
//
//  Created by apple on 2015/04/04.
//  Copyright (c) 2015年 Spinach. All rights reserved.
//

import UIkit

class TackListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var jsonData:JSON?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //自分のタックリストの読み込み
        let manager:AFHTTPRequestOperationManager = HTTPManager.HTTPRequestManagerFactory()
        var query = Setting.GET_COMMENT_URL + "user_id.eq." + LocalDataLogic.getUUID()
        manager.GET(query , parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject:AnyObject!) in
                println(responseObject)
                self.jsonData = JSON(responseObject)
                self.tableView.reloadData()
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("error: \(error)")
            }
        )
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerNib(UINib(nibName: "SelfTackList", bundle:nil), forCellReuseIdentifier: "SelfTackList")
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 189
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : SelfTackListCell = tableView.dequeueReusableCellWithIdentifier("SelfTackList", forIndexPath: indexPath) as SelfTackListCell
        
        
        if(jsonData == nil){
            
        }else{
            cell.placeLabel.text = self.jsonData!["_objs"][indexPath.row]["place"].string
            cell.bodyTextView.text = self.jsonData!["_objs"][indexPath.row]["comment"].string
            cell.goodTackCount.text = self.jsonData!["_objs"][indexPath.row]["tack_point"].stringValue
            
            if(self.jsonData!["_objs"][indexPath.row]["has_image"]){
                var imageUrl:String = "https://api-datastore.appiaries.com/v1/bin/_sandbox/Basho/image_latlang/" + self.jsonData!["_objs"][indexPath.row]["object_id"].string! + "/_bin"
                let url = NSURL(string: imageUrl)
                let imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
                let uiImage = UIImage(data: imageData!)
                
                cell.imagePicture.image = uiImage
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(jsonData == nil){
            return 1
        }else{
            var count : String? = self.jsonData!["_total"].stringValue
            return count!.toInt()!
        }
    }
    

    
    //LeftBoard
    @IBAction func openLeftBoard(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}
