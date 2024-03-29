//
//  OverSpeedRecord.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 28/10/20.
//

import UIKit

class SpeedRecord: Codable {
    var id:String?
    let currentSpeed:Double
    let limitedSpeed:Double
    let latitude:Double
    let longitude:Double
    let recordId:String?
    let recordTime:Date
    let overSpeed:Bool
    let facialId:String?
}
