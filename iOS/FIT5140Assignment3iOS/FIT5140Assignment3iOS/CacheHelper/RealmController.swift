//
//  RealmController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 18/11/20.
//

import Foundation
import RealmSwift

final class RealmController:CacheController{
    
    static let shared = RealmController()
    private var realm : Realm?
    
    private init(){
        //realm 支持多用户时使用这段代码
        //assign the db file path to by different user
        //active this code when enabling account switch.
        //but may move this code to somewhere else
        //        func setDefaultRealmForUser(username: String) {
        //            var config = Realm.Configuration()
        //
        //            // Use the default directory, but replace the filename with the username
        //            config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        //
        //            // Set this as the configuration used for the default Realm
        //            Realm.Configuration.defaultConfiguration = config
        //        }

        //https://realm.io/docs/swift/latest/#using-the-realm-framework
        //continue using realm when the phone is locked
        do {
            //create realm db instance
            realm  = try Realm()

            // Get our Realm file's parent directory
            let folderPath = realm?.configuration.fileURL!.deletingLastPathComponent().path
            print("Below is Realm File Path: \(String(describing: folderPath))")

            // Disable file protection for this directory
            try! FileManager.default.setAttributes([FileAttributeKey(rawValue: FileAttributeKey.protectionKey.rawValue): FileProtectionType.none], ofItemAtPath: folderPath!)
        } catch let error as NSError{
            print(error)
            //handle error
        }

    }
    
    func getPlaceDetailCacheData(_ placeId:String)->PlaceDetailResponse?{

        let queryResults = realm?.objects(PlaceDetailResponseRealmModel.self)

        //first fetch data from Realm DB
        if let noneEmptyQueryResults = queryResults {
            for queryResult in noneEmptyQueryResults {
                if queryResult.result?.placeID == placeId{
                    let placeDetailResponse = PlaceDetailResponse(placeDetailResponseRealmModel: queryResult)
                    return placeDetailResponse
                    //let predicate = NSPredicate(format: "placeID = %@", placeId)
                    //let firstResultOfRealmModel = results!.filter(predicate).first
                }
            }
        }
        return nil
    }
    
    func storePlaceDetailResponse(_ placeDetail: PlaceDetailResponse) {
        //converting placeDetail into Realm Model
        let location = PlaceDetailLocationRealmModel()
        location.lat.value = placeDetail.result.geometry.location.lat
        location.lng.value = placeDetail.result.geometry.location.lng

        let geometry = PlaceDetailGeometryRealmModel()
        geometry.location = location

        let viewport = PlaceDetailViewportRealmModel()
        let northeast = PlaceDetailLocationRealmModel()
        northeast.lat.value = placeDetail.result.geometry.viewport.northeast.lat
        northeast.lng.value = placeDetail.result.geometry.viewport.northeast.lng

        let southwest = PlaceDetailLocationRealmModel()
        southwest.lat.value = placeDetail.result.geometry.viewport.southwest.lat
        southwest.lng.value = placeDetail.result.geometry.viewport.southwest.lng

        viewport.northeast = northeast
        viewport.southwest = southwest
        geometry.viewport = viewport

        let result = PlaceDetailRealmModel()
        result.geometry = geometry

        let addressComponentsOriginal = placeDetail.result.addressComponents
        for address in addressComponentsOriginal{
            let addressComponent = AddressComponentRealmModel()
            addressComponent.types.append(objectsIn: address.types)
            addressComponent.longName = address.longName
            addressComponent.shortName = address.shortName
            result.addressComponents.append(addressComponent)
        }

        result.formattedAddress = placeDetail.result.formattedAddress
        result.icon = placeDetail.result.icon
        result.name = placeDetail.result.name
        result.placeID = placeDetail.result.placeID

        if let types = placeDetail.result.types{
            result.types.append(objectsIn: types)
        }

        let placeDetailResponseRealmModel = PlaceDetailResponseRealmModel()
        placeDetailResponseRealmModel.result = result

        //store into realm
        do{
            try realm?.write{
                realm?.add(placeDetailResponseRealmModel)
            }
        } catch {
            print(error)
        }
        return
    }
}

