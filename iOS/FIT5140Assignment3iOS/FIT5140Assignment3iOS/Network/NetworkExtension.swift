//
//  NetworkExtension.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation

extension HTTPRequestAction{
    func requestRestfulService(api:RestfulAPI, model:RequestModel){
        NetworkRequestTask(helper: RequestHelper(api: api, model: model), action: self).fetchDataFromSever()
    }

}


extension NSObject{
    func getJsonDecoder()->JSONDecoder{
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }
}
