//
//  BaseNetworkRequestController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

open class BaseNetworkRequestController: UIViewController,DefaultHttpRequestAction {
    
    final func addToCache(helper: RequestHelper, result: Any) {
        cacheResult[helper]=result
    }
    
    final func removeCache(helper: RequestHelper) {
        cacheResult.removeValue(forKey: helper)
    }
    

    func handleData(helper: RequestHelper, url: URLComponents){
        preconditionFailure("this method must be overridden")
    }
    
    var cacheResult:[RequestHelper:Any] = [:]

}

protocol DefaultHttpRequestAction:HTTPRequestAction {
    var cacheResult:[RequestHelper:Any]{get set}
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T) where T:Decodable
    func handleData(helper:RequestHelper,url:URLComponents)
    func extractDataFromHelper<T>(_ helper:RequestHelper) -> T? where T:Decodable
    func addToCache(helper:RequestHelper, result:Any)
    func removeCache(helper:RequestHelper)
}

extension DefaultHttpRequestAction{
    func requestRestfulService<T>(api: RestfulAPI, model: RequestModel,jsonType:T) where T:Decodable {
        NetworkRequestTask<T>(helper: RequestHelper(api: api, model: model), action: self).fetchDataFromSever()
    }
    
    func beforeExecution(helper: RequestHelper) {
        
    }
    
    func executionFailed(helper: RequestHelper, message: String, error: Error) {
        
    }
    func afterExecution<T>(helper: RequestHelper, url: URLComponents, response: T, rawData: Data) {
        addToCache(helper: helper, result: response)
        handleData(helper: helper, url: url)
        removeCache(helper: helper)
    }
    
    func extractDataFromHelper<T>(_ helper:RequestHelper) -> T? where T:Decodable{
        return cacheResult[helper] as? T
    }
}
