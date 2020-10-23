//
//  NetworkRequestTask.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import UIKit

class NetworkRequestTask<T> : NSObject where T:Decodable{
    let requestHelper:RequestHelper
    let requestAction:HTTPRequestAction
    
    //references on https://learnappmaking.com/codable-json-swift-how-to/
    //references on https://medium.com/@alfianlosari/building-simple-async-api-request-with-swift-5-result-type-alfian-losari-e92f4e9ab412
    init(helper:RequestHelper, action:HTTPRequestAction){
        self.requestHelper = helper
        self.requestAction = action
    }
    
    func fetchDataFromSever(){
        let urlAndComponents = buildRequestUrl()
        guard let url = urlAndComponents.0 else{
            return
        }
        requestAction.beforeExecution(helper: requestHelper)
        
        URLSession.shared.dataTask(with: url, result: {(result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let (response,data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        //TODO handle this
//                        self.requestAction.executionFailed(helper: requestHelper, message: "InvalidResponse", error: )
                        return
                    }
                    do{
                        let decoder = JSONDecoder()
                        let convertedData = try decoder.decode(T.self, from: data)
                        self.requestAction.afterExecution(helper: self.requestHelper, url: urlAndComponents.1, response: convertedData, rawData: data)
                    }catch let error{
                        print(error)
                    }
                    //self.requestAction.afterExecution(helper: self.requestHelper,url: urlAndComponents.1, response: data)
                    break
                case .failure(let error):
                    self.requestAction.executionFailed(helper: self.requestHelper, message: "Error happened", error: error)
                    break
                }
            }
            }).resume()
    }
    
    private func buildRequestUrl()->(URL?, URLComponents){
        let model = requestHelper.requestModel
        let api = requestHelper.restfulAPI
        let host = api.getRequestHost()
        var urlComponents = URLComponents()
        urlComponents.scheme = host.getScheme()
        urlComponents.host = host.getHostUrl()
        urlComponents.port = host.getPort()
        urlComponents.path = api.getRoute()
        let pathParameter = model.getPathParameter()
        for path in pathParameter{
            urlComponents.path += "/"+path
        }
        var queryItems:[URLQueryItem] = []
        for query in model.getQueryParameter(){
            queryItems.append(URLQueryItem(name: query.key, value: query.value))
        }
        urlComponents.queryItems = queryItems
        print(urlComponents.url?.absoluteString ?? "")
        return (urlComponents.url, urlComponents)
    }
}

extension URLSession{
    func dataTask(with url:URL,result:@escaping (Result<(URLResponse, Data),Error>)->Void)->URLSessionDataTask{
        return dataTask(with: url){(data,response,error)in
            if let error = error{
                print("error")
                result(.failure(error))
                return
            }
            
            guard let response = response, let data = data else{
                print("error")
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            print("success")
            result(.success((response,data)))
        }
    }
}
