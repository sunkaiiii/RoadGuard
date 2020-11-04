//
//  SnapToRoadsRequest.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 5/11/20.
//

import Foundation
import MapKit

//the format of the request references on https://developers.google.com/maps/documentation/roads/snap
struct SnapToRoadsRequest:SimpleRequestModel {
    let points:[CLLocationCoordinate2D]
    
    func getQueryParameter() -> [String : String] {
        var i = 0
        var pathString = ""
        while i<points.count {
            if i > 0{
                pathString += "|"
            }
            let point = points[i]
            pathString += "\(point.latitude),\(point.longitude)"
            i+=1
        }
        return ["path":pathString,"interpolate":"true","key":GoogleMapAPIKey]
    }
}
