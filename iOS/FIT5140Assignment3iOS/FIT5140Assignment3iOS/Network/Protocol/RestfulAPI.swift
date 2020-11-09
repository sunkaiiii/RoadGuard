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
    case roadsApi
    case overpass
    case placeApi
    func getHostUrl() -> String {
        switch self {
        case .roadsApi:
            return "roads.googleapis.com"
        case .overpass:
            return "www.overpass-api.de"
        case .placeApi:
            return "maps.googleapis.com"
        default:
            return ""
        }
    }
    
    func getPort() -> Int {
        switch self {
        default:
            return DEFAULT_HTTPS_PORT
        }
    }
    
    func getScheme() -> String {
        switch self {
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
    case placeDetail
    case snapToRoads
    case searchPlace
    
    func getRequestName() -> String {
        switch self {
        case .nearestRoads:
            return "NearestRoads"
        case .placeDetail:
            return "PlaceDetail"
        case .snapToRoads:
            return "SnapToRoads"
        case .searchPlace:
            return "SearchPlace"
        }
    }
    
    func getRoute() -> String {
        switch self {
        case .nearestRoads:
            return "/v1/nearestRoads"
        case .placeDetail:
            return "/maps/api/place/details"
        case .snapToRoads:
            return "/v1/snapToRoads"
        case .searchPlace:
            return "/maps/api/place/textsearch"
        }
    }
    
    func getRequestType() -> RequestType {
        switch self {
        default:
            return .GET
        }
    }
    
    
    func getRequestHost() -> RequestHost {
        switch self {
        case .nearestRoads:
            return .roadsApi
        case .placeDetail:
            return .placeApi
        case .snapToRoads:
            return .roadsApi
        case .searchPlace:
            return .placeApi
        }
    }
    
}

