//
//  OverSpeedRecord.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 28/10/20.
//

import UIKit

struct OverSpeedRecord: Codable {
    var id:String?
    let recordSpeed:Int
    let limitedSpeed:Int
    let latitude:Double
    let longitude:Double
    let roadName:Double
    let recordTime:Date
}
