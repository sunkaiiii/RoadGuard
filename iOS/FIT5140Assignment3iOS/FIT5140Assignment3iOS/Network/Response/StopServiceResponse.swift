//
//  StopServiceResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 20/11/20.
//

import Foundation

struct StopServiceResponse: Codable {
    let documentID: String?
    let isError: Bool
    let errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case documentID = "documentId"
        case isError, errorMessage
    }
}
