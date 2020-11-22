//
//  CachegableController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 18/11/20.
//

import Foundation

/**
 # Controller for the management of all cacheable objects
Similarly to the Firebase Controller, all cacheable responses should interact with the class that implements this interface. This reduces direct coupling to other logic.
 */
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
