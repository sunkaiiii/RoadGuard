//
//  RealmController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 18/11/20.
//

import Foundation


final class RealmController:CacheController{
    static let shared = RealmController()
    
    private init(){
    }
    
    func getPlaceDetailCacheData(_ placeId:String)->PlaceDetailResponse?{
        return nil
    }
    
    func storePlaceDetailResponse(_ placeDetail: PlaceDetailResponse) {
        return
    }
}




