//
//  SearchPlaceRequest.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 5/11/20.
//

import Foundation


//search format references on https://developers.google.com/places/web-service/search

struct SearchPlaceRequest:SimpleRequestModel, Equatable {
    let query:String
    
    func getQueryParameter() -> [String : String] {
        return ["query":query,"key":GoogleMapAPIKey]
    }
    
    func getPathParameter() -> [String] {
        return ["json"]
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool{
        return lhs.query == rhs.query
    }
}

