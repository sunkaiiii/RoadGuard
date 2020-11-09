//
//  SearchPlaceResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 5/11/20.
//

import Foundation

import Foundation

// MARK: - SnapToRoads
struct SnapToRoads: Codable {
    let results: [SearchPlaceResult]
}

// MARK: - Result
struct SearchPlaceResult: Codable {
    let geometry: PlaceGeometry
    let icon: String
    let id, name, placeID, reference: String
    let vicinity: String
    let photos: [Photo]?
    let types: [String]?

    enum CodingKeys: String, CodingKey {
        case geometry, icon, id, name
        case placeID = "place_id"
        case reference, vicinity, photos, types
    }
}

// MARK: - Geometry
struct PlaceGeometry: Codable {
    let location: PlaceLocationInformation
}

// MARK: - Location
struct PlaceLocationInformation: Codable {
    let lat, lng: Double
}

// MARK: - Photo
struct Photo: Codable {
    let height: Int
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case photoReference = "photo_reference"
        case width
    }
}
