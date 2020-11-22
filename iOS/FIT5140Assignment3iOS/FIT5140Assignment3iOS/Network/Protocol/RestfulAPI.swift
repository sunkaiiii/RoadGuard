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

/**
  Recording of information about a requested host, every network request must contain an implementation of this interface
 */
protocol Host {
    /**
      Usually a host address
     * Eg. www.google.com
     */
    func getHostUrl()->String
         
     ///The port used by the api, e.g. 80, 5000
    func getPort()->Int
    
    ///scheme is the type of request, e.g. HTTP, HTTPS, FTP
    func getScheme()->String
}

enum RequestHost:Host{
    case aws
    case firebase
    case roadsApi
    case overpass
    case placeApi
    case raspberryPi
    func getHostUrl() -> String {
        switch self {
        case .roadsApi:
            return "roads.googleapis.com"
        case .overpass:
            return "www.overpass-api.de"
        case .placeApi:
            return "maps.googleapis.com"
        case .raspberryPi:
            return "13.75.187.241"
        default:
            return ""
        }
    }
    
    func getPort() -> Int {
        switch self {
        case .raspberryPi:
            return RASPBERRY_PI_API_PORT
        default:
            return DEFAULT_HTTPS_PORT
        }
    }
    
    func getScheme() -> String {
        switch self {
        case .raspberryPi:
            return HTTP
        default:
            return HTTPS
        }
    }
}

/**
 # This interface must be implemented for all network requests
 In a web request, the full path to the request api is obtained based on the RequestHost and the router. Setting the header and the action according to the requestType
 */
protocol RestfulAPI {
    
    ///Choose an understandable name for the request, which will probably be used as the default prompt in case of an error.
    func getRequestName()->String
    
    ///route is usually a specific request path after the hostname, e.g. /api/getStatus
    func getRoute()->String
    
    ///GET,POST,PUT,DELETE...or more restful action
    func getRequestType()->RequestType
    
    /**
     - returns The host information will be used to obtain the full url
     */
    func getRequestHost()->RequestHost
}

enum RaspberryPiApi:RestfulAPI{
    case get_current_speed
    case get_speed_limit
    case get_current_server_status
    case start_service
    case stop_service
    
    func getRequestName() -> String {
        switch self {
        case .get_current_speed:
            return "getCurrentSpeed"
        case .get_speed_limit:
            return "getSpeedLimit"
        case .get_current_server_status:
            return "getCurrentServerStatus"
        case .start_service:
            return "startService"
        case .stop_service:
            return "StopService"
        }
    }
    
    func getRoute() -> String {
        switch self {
        case .get_current_speed:
            return "/api/get_current_speed"
        case .get_speed_limit:
            return "/api/get_current_speed_limit"
        case .get_current_server_status:
            return "/api/get_service_status"
        case .start_service:
            return "/api/start_recording"
        case .stop_service:
            return "/api/stop_recording"
        }
    }
    
    func getRequestType() -> RequestType {
        switch self {
        default:
            return .GET
        }
    }
    
    func getRequestHost() -> RequestHost {
        return .raspberryPi
    }
    
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

