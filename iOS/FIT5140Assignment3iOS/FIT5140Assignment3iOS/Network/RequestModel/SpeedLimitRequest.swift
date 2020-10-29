//
//  SpeedLimitRequest.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 27/10/20.
//

import UIKit

struct SpeedLimitRequest {
    let left:Double
    let right:Double
    let top:Double
    let bottom:Double

    func RequestSpeedLimit( onCompleted:@escaping (SpeedLimitResponse)->Void)  {
        guard let url = URL(string: "https://www.overpass-api.de/api/xapi?*[maxspeed=*][bbox=\(left),\(bottom),\(right),\(top)]") else {
            return
        }
        //mock data
//        guard let url = URL(string: "https://www.overpass-api.de/api/xapi?*[maxspeed=*][bbox=5.6283473,50.5348043,5.6285261,50.534884]") else {
//            return
//        }
        print(url.absoluteString.removingPercentEncoding)
        let task = URLSession.shared.dataTask(with: url){(data,response,error) in
            DispatchQueue.main.async {
                if let data = data{
                    print(data)
                    let response = SpeedLimitResponse(xmlData: data)
                    onCompleted(response)
                }
            }
        }
        task.resume()
    }
}
