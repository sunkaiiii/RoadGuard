//
//  HomeViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController,CLLocationManagerDelegate {
    
    let manager = CLLocationManager.init()
    var mapview:GMSMapView?
    let marker = GMSMarker()
    @IBOutlet weak var speedAlertView: SpeedAlertSuperView!
    @IBOutlet weak var speedNotificationView: SpeedNotificationSuperView!
    
    var lastPosition:CLLocationCoordinate2D?
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
        guard let locationInformation = locations.last else {
            return
        }
        print(locationInformation.coordinate.latitude,locationInformation.coordinate.longitude)
        let speed = locationInformation.speed
        speedAlertView.setCurrentSpeed(speed: String(format: "%d", abs(speed*3.6)))
        marker.position = locationInformation.coordinate
        marker.map = mapview
        let gmsCamera = GMSCameraPosition.camera(withLatitude: locationInformation.coordinate.latitude, longitude: locationInformation.coordinate.longitude, zoom: 19)
        mapview?.camera = gmsCamera
        
        if let lastPosition = lastPosition{
            requestMeasureTheSpeed(lastPosition: lastPosition, location: locationInformation)
        }else{
            lastPosition = locationInformation.coordinate
        }
    }
    
    func requestMeasureTheSpeed(lastPosition:CLLocationCoordinate2D, location:CLLocation){
        let coordinate = location.coordinate
        let left = lastPosition.longitude < coordinate.longitude ? lastPosition.longitude:coordinate.longitude
        let bottom = lastPosition.latitude < coordinate.latitude ? lastPosition.latitude:coordinate.latitude
        let right = lastPosition.longitude > coordinate.longitude ? lastPosition.longitude:coordinate.longitude
        let top = lastPosition.latitude > coordinate.latitude ? lastPosition.latitude:coordinate.latitude
        let request = SpeedLimitRequest(left: left, right: right, top: top, bottom: bottom)
        request.RequestSpeedLimit(onCompleted: {(response) in
            if !response.ways.isEmpty{
                let way = response.ways[0]
                self.speedNotificationView.setSpeedNotification("\(way.speedMaxSpeed)")
                let speed = fabs(location.speed * 3.6)
                if Int(speed) > way.speedMaxSpeed{
                    self.recordOverSpeed(currentSpeed: Int(speed), limitedSpeed: way.speedMaxSpeed, location: location)
                }
            }
        })
    }

    func recordOverSpeed(currentSpeed:Int, limitedSpeed:Int, location:CLLocation){
        
    }
}
