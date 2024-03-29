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
    var placeIds:[String]
    
    enum CodingKeys:String, CodingKey{
        case selectedRoadCustomName = "SelectedRoadCustomName"
        case userCustomImage = "UserCustomImage"
        case createTime = "CreateTime"
        case passedTime = "PassedTime"
        case selectedRoads = "SelectedRoads"
        case placeIds = "PlaceIds"
    }
    
    init(customName:String, storedUrl:String,roadInformation:[SnappedPointResponse]) {
        self.init(roadInformation: roadInformation)
        self.selectedRoadCustomName = customName
        self.userCustomImage = storedUrl
    }
    
    init(roadInformation:[SnappedPointResponse]) {
        self.createTime = Date.init()
        self.passedTime = nil
        self.userCustomImage = nil
        self.selectedRoads = roadInformation
        self.placeIds = roadInformation.map({(points) in points.placeID})
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.selectedRoadCustomName = "Date: "+dateFormatter.string(from: Date.init())
        
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

