//
//  RealmExtension.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/6.
////
//
import Foundation
import RealmSwift

//貌似新版本已经支持codable了
//现在再这么写 会提示已经实现codable了
//https://stackoverflow.com/questions/53332732/how-to-implement-codable-while-using-realm
//extension RealmSwift.List: Decodable where Element: Decodable {
//    public convenience init(from decoder: Decoder) throws {
//        self.init()
//        let container = try decoder.singleValueContainer()
//        let decodedElements = try container.decode([Element].self)
//        self.append(objectsIn: decodedElements)
//    }
//}
//
//extension RealmSwift.List: Encodable where Element: Encodable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(self.map { $0 })
//    }
//}

//https://stackoverflow.com/questions/45452833/how-to-use-list-type-with-codable-realmswift
//extension List : Decodable where Element : Decodable {
//    public convenience init(from decoder: Decoder) throws {
//        self.init()
//        var container = try decoder.unkeyedContainer()
//        while !container.isAtEnd {
//            let element = try container.decode(Element.self)
//            self.append(element)
//        }
//    } }
//
//extension List : Encodable where Element : Encodable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.unkeyedContainer()
//        for element in self {
//            try element.encode(to: container.superEncoder())
//        }
//    } }
