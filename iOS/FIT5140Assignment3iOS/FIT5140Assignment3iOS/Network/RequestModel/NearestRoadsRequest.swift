//
//  NearestRoadsRequest.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 3/11/20.
//

import Foundation

struct NearestRoadsRequest:SimpleRequestModel {

    let latitude:[Double]
    let longitude:[Double]

    
    init(lat:Double,log:Double) {
        self.latitude = [lat]
        self.longitude = [log]
    }
    
    init(lat:[Double],log:[Double]) {
        self.latitude = lat
        self.longitude = log
    }
    func getQueryParameter() -> [String : String] {
        var i = 0
        var content = ""
        while(i<latitude.count && i<longitude.count){
            if(i != 0){
                content += "|"
            }
            content += "\(latitude[i]),\(longitude[i])"
            i+=1
        }
        print("points: \(content)")
        return ["points":content,"key":GoogleMapAPI]
    }
}
