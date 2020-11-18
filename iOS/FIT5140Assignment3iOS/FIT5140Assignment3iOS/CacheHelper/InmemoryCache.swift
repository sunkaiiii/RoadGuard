//
//  InmemoryCache.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 18/11/20.
//

import Foundation
import MemoryCache

final class InMemoryDataCache:CacheController{


    
    public static let shared:CacheController = InMemoryDataCache()
    private let cache:MemoryCache
    
    private init(){
        cache = MemoryCache.default
    }
    
    func getPlaceDetailCacheData(_ placeId: String) -> PlaceDetailResponse? {
        let key = StringKey<PlaceDetailResponse>(placeId)
        let result = try? cache.value(for: key)
        let detail = result?.value
        return detail
    }
    
    func storePlaceDetailResponse(_ placeDetail: PlaceDetailResponse) {
        let key = StringKey<PlaceDetailResponse>(placeDetail.result.placeID)
        cache.set(placeDetail, for: key)
    }
    
    
}
