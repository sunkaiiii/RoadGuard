//
//  BaseNetworkRequestController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

///  Use this interface to provide consistent request behaviour for pages with similar web request logic
protocol DefaultHttpRequestAction:HTTPRequestAction {
    
    /**
     The request for a cacheable response requires a helper that implements CacheableData and executes the corresponding method in the helper during the execution of the web request.
     ***
     tryFetchCacheData -> has cache -> afterExecution,
     tryFetchCacheData -> no cache -> beforeExecution -> afterExection -> cacheData
     */
    func requestCachegableDataFromRestfulService<T>(api:RestfulAPI,model:RequestModel,jsonType:T.Type,cachegableHelper:CachegableData) where T:Decodable

    /**
     Requesting restful services, after a successful request,handleResponseDataFromRestfulRequest will be executed
     - parameter api: Implementation of RestfulAPI for building url
     - parameter model: Implmentation of RequestModel for building url
     - parameter jsonType: The return type of the response, needs to implement the Decodable interface
     */
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T.Type) where T:Decodable
    
    /**
     Requesting restful services, after a successful request, this will execute onDatareturned method and handleResponseDataFromRestfulRequest will NOT be executed
     - parameter api: Implementation of RestfulAPI for building url
     - parameter model: Implmentation of RequestModel for building url
     - parameter jsonType: The return type of the response, needs to implement the Decodable interface
     - parameter onDataReturned: Closures executed after the successful return of a request
     */
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T.Type, onDataReturned:@escaping(RequestHelper,URLComponents,T,Data)->Void) where T:Decodable
    
    /// Deprecated
    @available(*,deprecated,message:"no implementation for this method")
    func requestRestfulServiceForXmlResult(api:RestfulAPI, model:RequestModel)
    
    /**
     Handling the data from afterExecution function
     - parameter helper: contains the api and request model
     - parameter url: contains complete component of the url
     - parameter accessibleData: The data returned by the request will be wrapped in this class, and the return value can be obtained by declaring a return value type. For example, let response:GetNameresponse = accessibleData.retriveData()
     */
    func handleResponseDataFromRestfulRequest(helper:RequestHelper,url:URLComponents,accessibleData:AccessibleNetworkData)
}

protocol AccessibleNetworkData{
    /**
     Generic methods for handling afterExecution are wrapped using an object that implements such an object. The caller can simply provide the type of return value to obtain the corresponding class
     ***
     let response:AgeData = data.retriveData()
     */
    func retriveData<T>()->T
}

class DataResult:AccessibleNetworkData{
    let data:Any
    init(data:Any) {
        self.data = data
    }
    func retriveData<T>() -> T {
        return data as! T
    }
}

extension DefaultHttpRequestAction{
    func requestCachegableDataFromRestfulService<T>(api:RestfulAPI,model:RequestModel,jsonType:T.Type,cachegableHelper:CachegableData) where T:Decodable{
        let data:T? = cachegableHelper.tryFetchCacheData(request: model) as? T
        let helper = RequestHelper(api: api, model: model)
        if let data = data{
            handleResponseDataFromRestfulRequest(helper: helper, url: helper.buildUrlComponents().1, accessibleData: DataResult(data: data))
            return
        }
        
        requestRestfulService(api: api, model: model, jsonType: jsonType, onDataReturned: {(helper,components,result,rawData) in
            cachegableHelper.cacheData(data: result,request: model)
            afterExecution(helper: helper, url: components, response: result, rawData: rawData)
        })
    }
    func requestRestfulService<T>(api: RestfulAPI, model: RequestModel,jsonType:T.Type) where T:Decodable {
        NetworkRequestTask<T>(helper: RequestHelper(api: api, model: model), action: self).fetchDataFromSever()
    }
    
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T.Type, onDataReturned:@escaping(RequestHelper,URLComponents,T,Data)->Void) where T:Decodable{
        NetworkRequestTask<T>(helper: RequestHelper(api: api, model: model), action: self, onCompleted: onDataReturned).fetchDataFromSever()
    }
    
    func requestRestfulServiceForXmlResult(api:RestfulAPI, model:RequestModel){
        NetworkRequestTask<Data>(helper: RequestHelper(api: api, model: model), action: self).fetchDataFromSever()
    }
    
    func beforeExecution(helper: RequestHelper) {
        
    }
    
    func executionFailed(helper: RequestHelper, message: String, error: Error) {
        
    }
    func afterExecution<T>(helper: RequestHelper, url: URLComponents, response: T, rawData: Data) {
        handleResponseDataFromRestfulRequest(helper: helper, url: url, accessibleData: DataResult(data: response))
    }

}
