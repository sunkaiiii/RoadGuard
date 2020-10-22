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
    func getHostUrl() -> String {
        switch self {
        default:
            return ""
        }
    }
    
    func getPort() -> Int {
        switch self {
        default:
            return 0
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


