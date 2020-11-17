//
//  BaseNetworkRequestController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

protocol DefaultHttpRequestAction:HTTPRequestAction {
    func requestCachegableDataFromRestfulService<T>(api:RestfulAPI,model:RequestModel,jsonType:T.Type,cachegableHelper:CachegableData) where T:Decodable
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T.Type) where T:Decodable
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T.Type, onDataReturned:@escaping(RequestHelper,URLComponents,T,Data)->Void) where T:Decodable
    func requestRestfulServiceForXmlResult(api:RestfulAPI, model:RequestModel)
    func handleResponseDataFromRestfulRequest(helper:RequestHelper,url:URLComponents,accessibleData:AccessibleNetworkData)
}

protocol AccessibleNetworkData{
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
            cachegableHelper.cacheData(data: result)
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
