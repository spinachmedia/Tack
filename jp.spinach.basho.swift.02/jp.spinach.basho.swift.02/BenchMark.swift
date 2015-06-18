//
//  BenchMark.swift
//  jp.spinach.basho.swift.02
//
//  Created by 高橋洋樹 on 6/18/15.
//  Copyright (c) 2015 Spinach. All rights reserved.
//

import Foundation

class Benchmark {
    
    // 開始時刻を保存する変数
    var startTime: NSDate
    var key: String
    
    // 処理開始
    init(key: String) {
        self.startTime = NSDate()
        self.key = key
    }
    
    // 処理終了
    func finish() {
        let elapsed = NSDate().timeIntervalSinceDate(self.startTime) as Double
        let formatedElapsed = String(format: "%.3f", elapsed)
        println("Benchmark: \(key), Elasped time: \(formatedElapsed)(s)")
    }
    
    // 処理をブロックで受け取る
    class func measure(key: String, block: () -> ()) {
        let benchmark = Benchmark(key: key)
        block()
        benchmark.finish()
    }
}

//
//Benchmark.measure("重いかもしれない処理1", block: {
//    sleep(1)
//    return
//})


//// 生成に時間が掛かる重いクラス
//class MyHeavyClass {
//    init() {
//        sleep(1)
//    }
//    
//    func myMethod() {
//    }
//}
//
//Benchmark.measure("重いかもしれない処理2", block: {
//    let myHeavyValue = MyHeavyClass()
//})
//
//myHeavyValue.myMethod()
//// => Use of unresolved identifier 'myHeavyValue'