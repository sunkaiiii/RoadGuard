//
//  CachegableController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 18/11/20.
//

import Foundation

protocol CacheController {
    func getPlaceDetailCacheData(_ placeId:String)->PlaceDetailResponse?
    func storePlaceDetailResponse(_ placeDetail:PlaceDetailResponse)
    func getNearestRoadCacheData(_ request:NearestRoadsRequest)->NearestRoadResponse?
    func storeNearestRoadResponse(_ request:NearestRoadsRequest, _ response:NearestRoadResponse)
}

extension CacheController{
    func getNearestRoadCacheData(_ request:NearestRoadsRequest)->NearestRoadResponse?{
        return nil
    }
    func storeNearestRoadResponse(_ request:NearestRoadsRequest, _ response:NearestRoadResponse){
        return
    }
}
