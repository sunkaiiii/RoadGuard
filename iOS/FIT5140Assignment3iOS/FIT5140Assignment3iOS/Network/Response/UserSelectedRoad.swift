//
//  UserSelectedRoad.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 11/11/20.
//

import Foundation


struct UserSelectedRoadResponse:Codable {
    var id:String?
    var selectedRoadCustomName:String?
    var userCustomImage:String?
    let createTime:Date
    var passedTime:[SelectedRoadPassDetail]?
    var selectedRoads:[SnappedPointResponse]
    
    enum CodingKeys:String, CodingKey{
        case selectedRoadCustomName = "SelectedRoadCustomName"
        case userCustomImage = "UserCustomImage"
        case createTime = "CreateTime"
        case passedTime = "PassedTime"
        case selectedRoads = "SelectedRoads"
    }
    
    init(roadInformation:[SnappedPointResponse]) {
        self.createTime = Date.init()
        self.passedTime = nil
        self.userCustomImage = nil
        self.selectedRoads = roadInformation
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.selectedRoadCustomName = "Road_"+dateFormatter.string(from: Date.init())
        
    }
}

struct SelectedRoadPassDetail:Codable{
    let passedTime:Date
    let passedSpeed:Date
    let passedStatus:String?
    let distractionID:String?
    
    enum CodingKeys: String, CodingKey{
        case passedTime = "PassedTime"
        case passedSpeed = "PassedSpeed"
        case passedStatus = "PassedStatus"
        case distractionID = "DistractionID"
    }
}

