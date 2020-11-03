//
//  NearestRoadsResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 3/11/20.
//

import Foundation

// MARK: - NearestRoadResponse
struct NearestRoadResponse: Codable {
    let snappedPoints: [SnappedPoint]
}

// MARK: - SnappedPoint
struct SnappedPoint: Codable {
    let location: Location
    let originalIndex: Int
    let placeID: String

    enum CodingKeys: String, CodingKey {
        case location, originalIndex
        case placeID = "placeId"
    }
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude: Double
}
