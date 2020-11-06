//
//  PlaceDetailResponse.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 3/11/20.
//

import Foundation
import RealmSwift

// MARK: - PlaceDetailResponse
 class PlaceDetailResponse: Object, Codable {
    @objc dynamic var result: PlaceDetail?

    enum CodingKeys: String, CodingKey {
        case result
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decode(PlaceDetail.self, forKey: .result)
    }
}

// MARK: - Result
class PlaceDetail: Object, Codable {

    @objc dynamic var  formattedAddress: String? = nil
    @objc dynamic var  icon: String? = nil
    @objc dynamic var  name: String? = nil
    @objc dynamic var  placeID: String? = nil
    let addressComponents = List<AddressComponent>()

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case icon, name
        case placeID = "place_id"
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        formattedAddress = try container.decode(String.self, forKey: .formattedAddress)
        icon = try container.decode(String.self, forKey: .icon)
        name = try container.decode(String.self, forKey: .name)
        placeID = try container.decode(String.self, forKey: .placeID)
        let arrayAddressComponents = try container.decode([AddressComponent].self, forKey: .addressComponents)
        addressComponents.append(objectsIn: arrayAddressComponents)
    }
}

// MARK: - AddressComponent
class AddressComponent: Object,Codable {
    @objc dynamic var longName: String? = nil
    @objc dynamic var shortName: String? = nil
    let types = List<String>()

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        longName = try container.decode(String.self, forKey: .longName)
        shortName = try container.decode(String.self, forKey: .shortName)
        let typesArray = try container.decode([String].self, forKey: .types)
        types.append(objectsIn: typesArray)
    }
}


//备份
//// MARK: - PlaceDetailResponse
//class PlaceDetailResponse: Object,Codable {
//    @objc dynamic var result: PlaceDetail?
//}
//
//// MARK: - Result
//class PlaceDetail: Object, Codable {
//    var addressComponents: List<AddressComponent>?
//    @objc dynamic var  formattedAddress: String?
//    @objc dynamic var  icon: String?
//    @objc dynamic var  name, placeID: String?
//
//    enum CodingKeys: String, CodingKey {
//        case addressComponents = "address_components"
//        case formattedAddress = "formatted_address"
//        case icon, name
//        case placeID = "place_id"
//    }
//}
//
//// MARK: - AddressComponent
//class AddressComponent: Object,Codable {
//    @objc dynamic var  longName, shortName: String?
//    var  types: List<String>?
//
//    enum CodingKeys: String, CodingKey {
//        case longName = "long_name"
//        case shortName = "short_name"
//        case types
//    }
//}

//
//
//备份2
//class PlaceDetailResponse: Object, Codable {
//    @objc dynamic var result: PlaceDetail?
//
//    enum CodingKeys: String, CodingKey {
//        case result
//    }
//
//    init(result: PlaceDetail?) {
//        self.result = result
//    }
//}
//
//// MARK: - Result
//class PlaceDetail: Object, Codable {
//    let addressComponents = List<AddressComponent>()
//    @objc dynamic var  formattedAddress: String? = nil
//    @objc dynamic var  icon: String? = nil
//    @objc dynamic var  name: String? = nil
//    @objc dynamic var  placeID: String? = nil
//
//    enum CodingKeys: String, CodingKey {
//        case addressComponents = "address_components"
//        case formattedAddress = "formatted_address"
//        case icon, name
//        case placeID = "place_id"
//    }
//
//    init(addressComponents: [AddressComponent]?, formattedAddress: String?, icon: String?, name: String?, placeID: String?) {
//        self.formattedAddress = formattedAddress
//        self.icon = icon
//        self.name = name
//        self.placeID = placeID
//        self.addressComponents.append(objectsIn: addressComponents!)
//    }
//}
//
//// MARK: - AddressComponent
//class AddressComponent: Object,Codable {
//    @objc dynamic var longName: String? = nil
//    @objc dynamic var shortName: String? = nil
//    let types = List<String>()
//
//    enum CodingKeys: String, CodingKey {
//        case longName = "long_name"
//        case shortName = "short_name"
//        case types
//    }
//
//    init(types: [String]?, longName: String?, shortName: String?) {
//        self.longName = longName
//        self.shortName = shortName
//        self.types.append(objectsIn: types!)
//    }
//}
//
