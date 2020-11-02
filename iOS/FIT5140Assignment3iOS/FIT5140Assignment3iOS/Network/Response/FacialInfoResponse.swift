//
//  FacialInfoResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 1/11/20.
//

import Foundation
// MARK: - FacialInfo
struct FacialInfo: Codable {
    let id: String?
    let imageURL: String
    let faceDetails: [FaceDetail]
    let speed: Int
    let capturedTime: String
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "ImageUrl"
        case faceDetails = "FaceDetails"
        case speed = "Speed"
        case capturedTime = "CapturedTime"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
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
