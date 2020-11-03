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
}

enum GoogleApi:RestfulAPI{
    
    case nearestRoads
    
    func getRequestName() -> String {
        switch self {
        case .nearestRoads:
            return "NearestRoads"
        }
    }
    
    func getRoute() -> String {
        switch self {
        case .nearestRoads:
            return "/v1/nearestRoads"
        }
    }
    
    func getRequestType() -> RequestType {
        switch self {
        case .nearestRoads:
            return RequestType.GET
        }
    }
    
    
    func getRequestHost() -> RequestHost {
        switch self {
        case .nearestRoads:
            return RequestHost.roads_api
        }
    }
    
}

