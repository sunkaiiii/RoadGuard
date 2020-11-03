//
//  RestfulModel.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation

let HTTP_PORT = 80
let DEFAULT_HTTPS_PORT = 443


protocol RequestModel {
    func getPathParameter()->[String]
    func getHeader()->[String:String]
    func getQueryParameter()->[String:String]
    func getBody()->[String]
}

protocol SimpleRequestModel:RequestModel{
    
}
extension SimpleRequestModel{
    func getPathParameter() -> [String] {
        return []
    }
    func getBody() -> [String] {
        return []
    }
    func getHeader() -> [String : String] {
        return [:]
    }
}

protocol HTTPRequestAction {
    func beforeExecution(helper:RequestHelper)
    func executionFailed(helper:RequestHelper, message:String, error:Error)
    func afterExecution<T>(helper:RequestHelper,url:URLComponents,response:T, rawData:Data)
}

class RequestHelper: NSObject {
    let restfulAPI:RestfulAPI
    let requestModel:RequestModel
    
    init(api:RestfulAPI, model:RequestModel){
        self.restfulAPI = api
        self.requestModel = model
    }
}
