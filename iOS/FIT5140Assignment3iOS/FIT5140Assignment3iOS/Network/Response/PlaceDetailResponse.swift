//
//  PlaceDetailResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 3/11/20.
//

import Foundation

class PlaceDetailResponseCacheDataHelper:CachegableData{
    func tryFetchCacheData(request: RequestModel) -> Decodable? {
        if let placeDetailRequest = request as? PlaceDetailRequest{
            if let memoryCache =  InMemoryDataCache.shared.getPlaceDetailCacheData(placeDetailRequest.placeId){
                return memoryCache
            }
            return RealmController.shared.getPlaceDetailCacheData(placeDetailRequest.placeId)
        }
        return nil
    }

    func cacheData(data: Decodable,request:RequestModel) {
        if let data = data as? PlaceDetailResponse{
            InMemoryDataCache.shared.storePlaceDetailResponse(data)
            RealmController.shared.storePlaceDetailResponse(data)
        }
    }
}

// MARK: - PlaceDetailResponse
struct PlaceDetailResponse: Codable {
    let result: PlaceDetail

    public init(placeDetailResponseRealmModel: PlaceDetailResponseRealmModel){
        result = PlaceDetail(placeDetailRealmModel: placeDetailResponseRealmModel.result!)
    }
}

// MARK: - Result
struct PlaceDetail: Codable {
    
    let addressComponents: [AddressComponent]
    let formattedAddress: String
    let geometry: PlaceDetailGeometry
    let icon: String
    let name, placeID: String
    let types: [String]?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry, icon, name
        case placeID = "place_id"
        case types
    }

    public init(placeDetailRealmModel: PlaceDetailRealmModel){
        formattedAddress = placeDetailRealmModel.formattedAddress!
        icon = placeDetailRealmModel.icon!
        name = placeDetailRealmModel.name!
        placeID = placeDetailRealmModel.placeID!
        geometry = PlaceDetailGeometry(placeDetailGeometryRealmModel: placeDetailRealmModel.geometry!)

        var stringArray : [String] = []
        for element in placeDetailRealmModel.types{
            stringArray.append(element)
        }
        types = stringArray

        var addressArray : [AddressComponent] = []
        for element in placeDetailRealmModel.addressComponents{
            addressArray.append(AddressComponent(addressComponentRealmModel: element))
        }
        addressComponents = addressArray
    }
}

struct AddressComponent: Codable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }

    public init(addressComponentRealmModel: AddressComponentRealmModel){
        longName = addressComponentRealmModel.longName!
        shortName = addressComponentRealmModel.shortName!
        var stringArray : [String] = []
        for element in addressComponentRealmModel.types{
            stringArray.append(element)
        }
        types = stringArray
    }
}

// MARK: - Geometry
struct PlaceDetailGeometry: Codable {
    let location: PlaceDetailLocation
    let viewport: PlaceDetailViewport

    public init(placeDetailGeometryRealmModel: PlaceDetailGeometryRealmModel){
        location = PlaceDetailLocation(placeDetailLocationRealmModel: placeDetailGeometryRealmModel.location!)
        viewport = PlaceDetailViewport(placeDetailViewportRealmModel: placeDetailGeometryRealmModel.viewport!)
    }
}

// MARK: - Viewport
struct PlaceDetailViewport: Codable {
    let northeast, southwest: PlaceDetailLocation

    public init(placeDetailViewportRealmModel: PlaceDetailViewportRealmModel){
        northeast = PlaceDetailLocation(placeDetailLocationRealmModel: placeDetailViewportRealmModel.northeast!)
        southwest = PlaceDetailLocation(placeDetailLocationRealmModel: placeDetailViewportRealmModel.southwest!)
    }
}

// MARK: - Location
struct PlaceDetailLocation: Codable {
    let lat, lng: Double

    public init(placeDetailLocationRealmModel: PlaceDetailLocationRealmModel){
        lat = placeDetailLocationRealmModel.lat.value!
        lng = placeDetailLocationRealmModel.lng.value!
    }
}


