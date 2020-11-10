//
//  UserSelectedRoad.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 11/11/20.
//

import Foundation

struct UserSelectedRoadResponse:CodeableRoadInforamtion {
    var id:String?
    
    let placeID: String
    
    let name: String
    
    let formatName: String
    
    let latitude: Double
    
    let longitude: Double
    
    let icon: String?
    
    var userCustomImage:String?
    
    let createTime:Date
    
    var passedTime:[SelectedRoadPassDetail]?
    
    var roadLimitedSpeed:Int?
    
    init(roadDetail:RoadInformation) {
        self.placeID = roadDetail.placeID
        self.name = roadDetail.name
        self.formatName = roadDetail.formatName
        self.latitude = roadDetail.latitude
        self.longitude = roadDetail.longitude
        self.icon = roadDetail.icon
        self.createTime = Date.init()
        self.passedTime = nil
        self.roadLimitedSpeed = nil
    }
    
    init(roadDetail:UserSelectedRoadResponse) {
        self.init(roadDetail: roadDetail as RoadInformation)
        self.passedTime = roadDetail.passedTime
        self.roadLimitedSpeed = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case placeID = "PlaceID"
        case name = "Name"
        case formatName = "FormatName"
        case latitude = "Latidude"
        case longitude = "Longitude"
        case icon = "Icon"
        case userCustomImage = "UserCustomImage"
        case createTime = "CreateTime"
        case passedTime = "PassedTime"
        case roadLimitedSpeed = "RoadLimitedSpeed"
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

