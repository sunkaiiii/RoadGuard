//
//  PlaceDetailRequest.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 3/11/20.
//

import Foundation

struct PlaceDetailRequest:SimpleRequestModel {
    let placeId:String
    func getQueryParameter() -> [String : String] {
        return ["place_id":placeId,"fields":"formatted_address,address_components,place_id,name,icon,geometry,types","key":GoogleMapAPIKey]
    }
    func getPathParameter() -> [String] {
        return ["json"]
    }
}
