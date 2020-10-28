//
//  OverSpeedRecord.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 28/10/20.
//

import UIKit

class OverSpeedRecord: Codable {
    var id:String?
    let recordSpeed:Int
    let limitedSpeed:Int
    let latitude:Double
    let longitude:Double
    let roadName:String?
    let recordTime:Date
    
    init(recordSpeed:Int, limitedSpeed:Int,lat:Double,log:Double,roadName:String?) {
        self.recordSpeed = recordSpeed
        self.limitedSpeed = limitedSpeed
        self.latitude = lat
        self.longitude = log
        self.roadName = roadName
        self.recordTime = Date.init()
    }
}
