//
//  FacialInfoResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 1/11/20.
//

import Foundation
// MARK: - FacialInfo
struct FacialInfo: Codable {
    var id: String?
    let imageURL: String
    let faceDetails: [FaceDetail]
    let speed: Int
    let recordId:String?
    let locationInfo:FacialLocation?
    let selectedRoadIds:[String]?
    let capturedTime: Date

    enum CodingKeys: String, CodingKey {
        case imageURL = "ImageUrl"
        case faceDetails = "FaceDetails"
        case speed = "speed"
        case capturedTime = "CapturedTime"
        case locationInfo = "location_info"
        case recordId
        case selectedRoadIds
    }
}
struct FacialLocation: Codable {
    let latitude, longitude: Double?
}

// MARK: - FaceDetail
struct FaceDetail: Codable {
    let emotions: [Emotion]
    let pose: Pose

    enum CodingKeys: String, CodingKey {
        case emotions = "Emotions"
        case pose = "Pose"
    }
}

// MARK: - Emotion
struct Emotion: Codable {
    let type: String
    let confidence: Double

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case confidence = "Confidence"
    }
}

// MARK: - Pose
struct Pose: Codable {
    let roll, yaw, pitch: Double

    enum CodingKeys: String, CodingKey {
        case roll = "Roll"
        case yaw = "Yaw"
        case pitch = "Pitch"
    }
}
