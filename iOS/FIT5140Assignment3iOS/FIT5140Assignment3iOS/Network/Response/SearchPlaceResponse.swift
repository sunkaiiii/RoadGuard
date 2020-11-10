//
//  SearchPlaceResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 5/11/20.
//

import Foundation

// MARK: - SearchPlaceResponse
class SearchPlaceResponse: Codable {
    let results: [SearchPlaceDetail]

    init(results: [SearchPlaceDetail]) {
        self.results = results
    }
}

// MARK: - Result
class SearchPlaceDetail: Codable {
    let formattedAddress: String
    let geometry: SearchPlaceGeometry
    let icon: String
    let name, placeID: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case geometry, icon, name
        case placeID = "place_id"
        case types
    }

    init(formattedAddress: String, geometry: SearchPlaceGeometry, icon: String, name: String, placeID: String, types: [String]) {
        self.formattedAddress = formattedAddress
        self.geometry = geometry
        self.icon = icon
        self.name = name
        self.placeID = placeID
        self.types = types
    }
}

// MARK: - Geometry
class SearchPlaceGeometry: Codable {
    let location: SearchPlaceLocation
    let viewport: SearchPlaceViewport

    init(location: SearchPlaceLocation, viewport: SearchPlaceViewport) {
        self.location = location
        self.viewport = viewport
    }
}

// MARK: - Location
class SearchPlaceLocation: Codable {
    let lat, lng: Double

    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

// MARK: - Viewport
class SearchPlaceViewport: Codable {
    let northeast, southwest: SearchPlaceLocation

    init(northeast: SearchPlaceLocation, southwest: SearchPlaceLocation) {
        self.northeast = northeast
        self.southwest = southwest
    }
}
