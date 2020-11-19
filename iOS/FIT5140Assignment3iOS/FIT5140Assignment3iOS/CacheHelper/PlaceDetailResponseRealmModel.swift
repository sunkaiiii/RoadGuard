//
//  PlaceDetailResponseRealmModel.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/18.
//

import Foundation
import RealmSwift

// MARK: - PlaceDetailResponse
class PlaceDetailResponseRealmModel: Object {
    @objc dynamic var result: PlaceDetailRealmModel?
}

// MARK: - Result
class PlaceDetailRealmModel: Object {
    let addressComponents = List<AddressComponentRealmModel>()
    @objc dynamic var formattedAddress: String? = nil
    @objc dynamic var geometry: PlaceDetailGeometryRealmModel?
    @objc dynamic var icon: String? = nil
    @objc dynamic var name : String? = nil
    @objc dynamic var  placeID: String? = nil
    let types = List<String>()
}

class AddressComponentRealmModel: Object {
    @objc dynamic var longName: String? = nil
    @objc dynamic var shortName: String? = nil
    let types = List<String>()
}

// MARK: - Geometry
class PlaceDetailGeometryRealmModel: Object {
    @objc dynamic var location: PlaceDetailLocationRealmModel?
    @objc dynamic var viewport: PlaceDetailViewportRealmModel?
}

// MARK: - Viewport
class PlaceDetailViewportRealmModel: Object {
    @objc dynamic var northeast: PlaceDetailLocationRealmModel?
    @objc dynamic var southwest: PlaceDetailLocationRealmModel?
}


// MARK: - Location
class PlaceDetailLocationRealmModel: Object {
    let lat = RealmOptional<Double>()
    let lng = RealmOptional<Double>()
}

