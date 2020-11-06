//
//  AppDelegate.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var firebaseController:DatabaseProtocol?
    var realm : Realm?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(GoogleMapAPIKey)
        GMSPlacesClient.provideAPIKey(GoogleMapAPIKey)
        firebaseController = FirebaseController()

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
            realm  = try Realm()
            // Get our Realm file's parent directory
            let folderPath = realm?.configuration.fileURL!.deletingLastPathComponent().path
//            print("foldre path is coming")
//            print("\(String(describing: folderPath))")

            // Disable file protection for this directory
            try! FileManager.default.setAttributes([FileAttributeKey(rawValue: FileAttributeKey.protectionKey.rawValue): FileProtectionType.none], ofItemAtPath: folderPath!)

        } catch let error as NSError{
            print(error)
            //handle error
        }
//        print("foldre path is coming2")
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

