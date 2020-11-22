//
//  CachegableData.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 17/11/20.
//

import Foundation

/**
 # Caching of data from network requests
 ## The cache can be any type of cache, but currently only provides access in a synchronous manner
 */
protocol CachegableData {
    /**
     #Get a cache
     - parameter request: The request is equivalent to a key in a dictionary and is used to get a unique cache value
     - returns: If the cache exists, it will be returned in the same way as the response form of the network request, and the recipient can safely perform a type conversion to correspond to the return type of the network request.
     */
    func tryFetchCacheData(request:RequestModel)->Decodable?
    /**
     # Caching response data
     ****
     The execution takes place after the afterExecution of the HTTPAction, at which point the file is cached. The caching is done by default on the UI thread, so be aware of the performance.
     - parameter data:data must be decodable and is usually used for json conversion.
     - parameter request: The cache design will use a unique value in the request to locate the corresponding cache. The implementor needs to translate this to the corresponding request to define a unique key.
     */
    func cacheData(data:Decodable,request:RequestModel)
}
