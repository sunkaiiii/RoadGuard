//
//  HomeViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController,CLLocationManagerDelegate, DefaultHttpRequestAction {
    
    let manager = CLLocationManager.init()
    var mapview:GMSMapView?
    let marker = GMSMarker()
    @IBOutlet weak var speedAlertView: SpeedAlertSuperView!
    @IBOutlet weak var speedNotificationView: SpeedNotificationSuperView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationPermission()
        initGoogleMap()
    }
    
    func initLocationPermission() {
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.delegate = self
        manager.distanceFilter = 30
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation", completion: {
            error in
            if let error = error{
                print(error)
            }
            self.manager.startUpdatingLocation()
        })
    }

    func initGoogleMap(){
        let gmsCamera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapview = GMSMapView.map(withFrame: self.view.frame, camera: gmsCamera)
        if let mapview = mapview{
            self.view.addSubview(mapview)
            mapview.layer.zPosition = -.greatestFiniteMagnitude
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loationInformation = locations.last else {
            return
        }
        print(loationInformation.coordinate.latitude,loationInformation.coordinate.longitude)
        let speed = loationInformation.speed
        speedAlertView.setCurrentSpeed(speed: String(format: "%d", abs(speed*3.6)))
        marker.position = loationInformation.coordinate
        marker.map = mapview
        let gmsCamera = GMSCameraPosition.camera(withLatitude: loationInformation.coordinate.latitude, longitude: loationInformation.coordinate.longitude, zoom: 19)
        mapview?.camera = gmsCamera
    }
    
    func handleData(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        
    }
}
