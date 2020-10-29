//
//  SpeedLimitResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 27/10/20.
//

import Foundation

struct SpeedLimit{
    var speedName:String
    var speedMaxSpeed:Int
}


//parse xml
//references on https://www.ioscreator.com/tutorials/parse-xml-ios-tutorial
class SpeedLimitResponse:NSObject,XMLParserDelegate{
    var ways:[SpeedLimit] = []
    var elementName: String = String()
    var roadName = String()
    var maxSpeed = 0
    var speedLimit = SpeedLimit(speedName: "", speedMaxSpeed: 0)
    
    init(xmlData:Data) {
        super.init()
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "way"{
            speedLimit = SpeedLimit(speedName: "", speedMaxSpeed: 0)
        }
        if elementName == "tag" && attributeDict["k"] == "maxspeed"{
            speedLimit.speedMaxSpeed = Int(attributeDict["v"] ?? "") ?? 0
        }
        if elementName == "tag" && attributeDict["k"] == "name"{
            speedLimit.speedName = attributeDict["v"] ?? ""
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "way"{
            if speedLimit.speedMaxSpeed > 0{
                ways.append(speedLimit)
            }
        }
    }

}
