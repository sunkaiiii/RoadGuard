//
//  SnapToRoadsResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 5/11/20.
//

import Foundation

// MARK: - Location
struct LocationInformation: Codable {
    let latitude, longitude: Double
}
// MARK: - SnappedPoint
struct SnappedPointResponse: Codable {
    let location: LocationInformation
    let originalIndex: Int?
    let placeID: String

    enum CodingKeys: String, CodingKey {
        case location, originalIndex
        case placeID = "placeId"
    }
}
// MARK: - SnapToRoadsResponse
struct SnapToRoadsResponse: Codable {
    let snappedPoints: [SnappedPointResponse]
}




