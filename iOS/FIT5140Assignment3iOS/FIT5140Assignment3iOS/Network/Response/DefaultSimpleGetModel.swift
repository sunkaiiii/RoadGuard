//
//  DefaultSimpleGetModel.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 15/11/20.
//

import Foundation

struct DefaultSimpleGetModel:SimpleRequestModel{
    func getQueryParameter() -> [String : String] {
        return [:]
    }
}
