//
//  CachegableData.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 17/11/20.
//

import Foundation


protocol CachegableData {
    func tryFetchCacheData(request:RequestModel)->Decodable?
    func cacheData(data:Decodable)
}
