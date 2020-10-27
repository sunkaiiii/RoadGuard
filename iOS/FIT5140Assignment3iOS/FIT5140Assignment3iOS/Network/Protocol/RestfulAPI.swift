//
//  RestfulAPI.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation

let HTTP="http"
let HTTPS = "https"
enum RequestType{
    case GET
    case POST
    case PUT
    case DELETE
}

enum DataFormat {
    case json
    case xml
}

protocol Host {
    func getHostUrl()->String
    func getPort()->Int
    func getScheme()->String
}

enum RequestHost:Host{
    case aws
    case firebase
    case roads_api
    case overpass
    func getHostUrl() -> String {
        switch self {
        case .roads_api:
            return "roads.googleapis.com"
        case .overpass:
            return "www.overpass-api.de"
        default:
            return ""
        }
    }
    
    func getPort() -> Int {
        switch self {
        case .roads_api:
            return DEFAULT_HTTPS_PORT
        case .overpass:
            return DEFAULT_HTTPS_PORT
        default:
            return 0
        }
    }
    
    func getScheme() -> String {
        switch self {
        case .roads_api:
            return HTTPS
        default:
            return HTTPS
        }
    }
}

protocol RestfulAPI {
    func getRequestName()->String
    func getRoute()->String
    func getRequestType()->RequestType
    func getRequestHost()->RequestHost
    func getReturnedDataFormat()->DataFormat
}


enum OpenMap:RestfulAPI {
    
    case getSpeedLimit
    
    func getRequestName() -> String {
        switch self {
        case .getSpeedLimit:
            return "getSpeedLimit"
        }
    }
    
    func getRoute() -> String {
        switch self{
        case .getSpeedLimit:
            return "/api/xapi"
        }
    }
    
    func getRequestType() -> RequestType {
        return RequestType.GET
    }
    
    func getRequestHost() -> RequestHost {
        return RequestHost.overpass
    }
    
    func getReturnedDataFormat() -> DataFormat {
        return .xml
    }
}

enum GoogleApi:RestfulAPI{
    
    case speedLimit
    
    func getRequestName() -> String {
        switch self {
        case .speedLimit:
            return "SpeedLimit"
        }
    }
    
    func getRoute() -> String {
        switch self {
        case .speedLimit:
            return "/v1/speedLimits"
        }
    }
    
    func getRequestType() -> RequestType {
        switch self {
        case .speedLimit:
            return RequestType.GET
        }
    }
    
    func getReturnedDataFormat() -> DataFormat {
        return .json
    }
    
    func getRequestHost() -> RequestHost {
        switch self {
        case .speedLimit:
            return RequestHost.roads_api
        }
    }
    
}

