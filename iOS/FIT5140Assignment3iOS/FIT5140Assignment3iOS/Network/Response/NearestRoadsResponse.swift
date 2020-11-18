//
//  NearestRoadsResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 3/11/20.
//

import Foundation

// MARK: - NearestRoadResponse
struct NearestRoadResponse: Codable {
    let snappedPoints: [SnappedPoint]
}

class NearestRoadResponseCacheHelper:CachegableData{
    func tryFetchCacheData(request: RequestModel) -> Decodable? {
        if let request = request as? NearestRoadsRequest{
            return InMemoryDataCache.shared.getNearestRoadCacheData(request)
        }
        return nil
    }

    func cacheData(data: Decodable,request:RequestModel) {
        if let request = request as? NearestRoadsRequest, let data = data as? NearestRoadResponse{
            InMemoryDataCache.shared.storeNearestRoadResponse(request, data)
        }

    }

    
}

// MARK: - SnappedPoint
struct SnappedPoint: Codable {
    let location: Location
    let originalIndex: Int
    let placeID: String

    enum CodingKeys: String, CodingKey {
        case location, originalIndex
        case placeID = "placeId"
    }
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude: Double
}
