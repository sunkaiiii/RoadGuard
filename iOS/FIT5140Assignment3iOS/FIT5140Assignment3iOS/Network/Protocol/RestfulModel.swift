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

/**
 # This interface should be implemented in the request model for all network requests
 The information provided by the model will be an integral part of the request.
 */
protocol RequestModel {
    /**
     In general, the pathParameter is used to perform the functions of the router.
     - returns When the return array is [1,2], it will add /1/2 to the scheme://host/path.
     */
    func getPathParameter()->[String]
    
    /**
     The header is used to convert the key-pair to be placed in the request
     - returns: Some requests such as Oauth2 authentication require tokens to be placed in the header. When ["token": "xxx"] is returned, the dictionary is put into the corresponding to the request.
     */
    func getHeader()->[String:String]
    
    /**
     The request will usually contain a query request that returns the dictionary of the query.
     - returns:When returning e.g. ["name": "abc", "age",15], it will be converted to the corresponding query string to be added to the scheme://host/path?{query}. i.e. scheme://host/path?name=abc&&age=15
     */
    func getQueryParameter()->[String:String]
    
    /**
     In post requests, data will also need to be stored in the body
     - returns: data that needs to be posted.
     */
    func getBody()->[String]
}

/**
 Default implementation for simple GET requests designed for most requests
 # For most requests that only require query, provide a default implementation of other less frequently used parameters
 */
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

/**
 Every entity that is going to make a network request should implement this interface to register it in the network request pipeline.
 ***
 At various stages in the request process, the corresponding callback is triggered
 */
protocol HTTPRequestAction {
    /**
     This method will be executed in the UI thread before the network request occurs.
     ***
     Best practice is to process the UI in the corresponding method block, depending on the api or request. E.g. disabling interaction, or displaying loading boxes
     */
    func beforeExecution(helper:RequestHelper)
    
    /**
     This method is executed when an error occurs on the request (http error code is not 200-299 or json conversion failed).
     ***
     The implemention can alert or roll back the UI as necessary, depending on the api and the request.
     */
    func executionFailed(helper:RequestHelper, message:String, error:Error)
    
    /**
     This method is executed when the network request is successful, this method is executed in the UI threads
     ***
     For implementation, this method is generic, meaning that it can be automatically converted to the required response, but needs to be designed by the implementation itself. The method itself focuses only on the process of providing data
     */
    func afterExecution<T>(helper:RequestHelper,url:URLComponents,response:T, rawData:Data)
}

///Every network request has a helper, which holds the api of the request and the request data entity.
class RequestHelper: NSObject {
    let restfulAPI:RestfulAPI
    let requestModel:RequestModel
    
    init(api:RestfulAPI, model:RequestModel){
        self.restfulAPI = api
        self.requestModel = model
    }
    
    /**
     Construct the complete request url based on the host protocol and the model protocol held.
     ***
     In the order in which they are built, they are in the following order: scheme -> host -> port -> route -> pathParameter -> queryParameter
     */
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
