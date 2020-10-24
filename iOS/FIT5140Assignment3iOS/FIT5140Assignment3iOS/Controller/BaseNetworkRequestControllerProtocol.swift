//
//  BaseNetworkRequestController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

protocol DefaultHttpRequestAction:HTTPRequestAction {
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T.Type) where T:Decodable
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T.Type, onDataReturned:@escaping(RequestHelper,URLComponents,T)->Void) where T:Decodable
    func handleData(helper:RequestHelper,url:URLComponents,accessibleData:AccessibleNetworkData)
}

protocol AccessibleNetworkData{
    func retriveData<T>(helper:RequestHelper)->T? where T:Decodable
}

class DataResult:AccessibleNetworkData{
    let data:Any
    init(data:Any) {
        self.data = data
    }
    func retriveData<T>(helper:RequestHelper) -> T? where T:Decodable {
        return data as? T
    }
}

extension DefaultHttpRequestAction{
    func requestRestfulService<T>(api: RestfulAPI, model: RequestModel,jsonType:T.Type) where T:Decodable {
        NetworkRequestTask<T>(helper: RequestHelper(api: api, model: model), action: self).fetchDataFromSever()
    }
    
    func requestRestfulService<T>(api:RestfulAPI, model:RequestModel,jsonType:T.Type, onDataReturned:@escaping(RequestHelper,URLComponents,T)->Void) where T:Decodable{
        NetworkRequestTask<T>(helper: RequestHelper(api: api, model: model), action: self, onCompleted: onDataReturned).fetchDataFromSever()
    }
    
    func beforeExecution(helper: RequestHelper) {
        
    }
    
    func executionFailed(helper: RequestHelper, message: String, error: Error) {
        
    }
    func afterExecution<T>(helper: RequestHelper, url: URLComponents, response: T, rawData: Data) {
        handleData(helper: helper, url: url, accessibleData: DataResult(data: response))
    }

}
