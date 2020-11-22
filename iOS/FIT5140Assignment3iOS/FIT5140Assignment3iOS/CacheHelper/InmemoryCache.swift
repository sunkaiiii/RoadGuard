//
//  InmemoryCache.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 18/11/20.
//

import Foundation
import MemoryCache

/**
 # Implementation of memory cache, not persistent
 This is the first level of cache used for the fastest response to an already cached network request. cache access is thread-safe.
 */
final class InMemoryDataCache:CacheController{


    
    public static let shared:CacheController = InMemoryDataCache()
    
    /**
     * NSCache is one of the candidate delegate classes, however, it is not suitable for data caching of non-class types.
     * ***
     * Note: After downloading from the pod, the visibility differs from today as it uses an older swift version. Therefore some members of the MemoryCache need to be added manually as public.
     */
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
