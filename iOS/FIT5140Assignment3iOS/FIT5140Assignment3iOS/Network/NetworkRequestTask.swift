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
    let onCompltedAction:((RequestHelper,URLComponents,T,Data)->Void)?
    
    //references on https://learnappmaking.com/codable-json-swift-how-to/
    //references on https://medium.com/@alfianlosari/building-simple-async-api-request-with-swift-5-result-type-alfian-losari-e92f4e9ab412
    convenience init(helper:RequestHelper, action:HTTPRequestAction){
        self.init(helper: helper, action: action, onCompleted: nil)
    }
    
    init(helper:RequestHelper, action:HTTPRequestAction, onCompleted: ((RequestHelper,URLComponents,T,Data)->Void)?) {
        self.requestHelper = helper
        self.requestAction = action
        self.onCompltedAction = onCompleted
    }
    
    func fetchDataFromSever(){
        let urlAndComponents = requestHelper.buildUrlComponents()
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
                        if let onCompleted = self.onCompltedAction{
                            onCompleted(self.requestHelper,urlAndComponents.1,convertedData,data)
                        }else{
                            self.requestAction.afterExecution(helper: self.requestHelper, url: urlAndComponents.1, response: convertedData, rawData: data)
                        }
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
