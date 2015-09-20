//
//  TackImageView.swift
//  jp.spinach.basho.swift.02
//
//  Created by 高橋洋樹 on 6/18/15.
//  Copyright (c) 2015 Spinach. All rights reserved.
//

import UIKit


//タップの結果をメイン画面に伝播するためのデリゲートプロトコル
protocol TackImageViewDelegate{
    func moveCameraToMarker(tackId : String ,lat : Double ,lng : Double)
}

class TackImageView: UIImageView {
    
    var delegate : TackImageViewDelegate?
    
    var tackId : String = ""
    
    var lat : Double = 0.0
    var lng : Double = 0.0
    
    
    var touchX : Double = 0.0
    var touchY : Double = 0.0
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        Log.debugStartLog()
        Log.debugLogWithTime("近隣のタックリストのタップ")
        
        if let i = delegate {
            delegate!.moveCameraToMarker(tackId,lat: lat,lng: lng)
        }
        
        Log.debugEndLog()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        Log.debugStartLog()
        
        
        
        Log.debugEndLog()
    }
    

}
