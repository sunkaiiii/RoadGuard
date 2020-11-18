//
//  DrivingRecordResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 16/11/20.
//

import Foundation


// MARK: - DrivingRecordResponse
struct DrivingRecordResponse: Codable {
    var id:String?
    let path: [DrivingPath]
    let drivingDistance: Double
    let startTime: Date
    let startLocation: DrivingLocation
    let endTime: Date
    let endLocation: DrivingLocation
}

// MARK: - Location
struct DrivingLocation: Codable {
    let latitude, logitude: Double
}

// MARK: - Path
struct DrivingPath: Codable {
    let latitude, longitude: Double
}
