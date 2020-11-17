//
//  RestfulModel.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation

let HTTP_PORT = 80
let DEFAULT_HTTPS_PORT = 443
let RASPBERRY_PI_API_PORT = 5000

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
    
    func buildUrlComponents()->(URL?, URLComponents){
        let host = restfulAPI.getRequestHost()
        var urlComponents = URLComponents()
        urlComponents.scheme = host.getScheme()
        urlComponents.host = host.getHostUrl()
        urlComponents.port = host.getPort()
        urlComponents.path = restfulAPI.getRoute()
        let pathParameter = requestModel.getPathParameter()
        for path in pathParameter{
            urlComponents.path += "/"+path
        }
        var queryItems:[URLQueryItem] = []
        for query in requestModel.getQueryParameter(){
            queryItems.append(URLQueryItem(name: query.key, value: query.value))
        }
        if queryItems.count > 0{
            urlComponents.queryItems = queryItems
        }
        print(urlComponents.url?.absoluteString ?? "")
        return (urlComponents.url, urlComponents)
    }
}
