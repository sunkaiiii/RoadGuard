//
//  HomeViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import UIKit
import GoogleMaps
import AVFoundation

class HomeViewController: UIViewController,CLLocationManagerDelegate {
    var player:AVAudioPlayer!
    let manager = CLLocationManager.init()
    var mapview:GMSMapView?
    let marker = GMSMarker()
    weak var firebaseController:DatabaseProtocol?
    @IBOutlet weak var speedAlertView: SpeedAlertSuperView!
    @IBOutlet weak var speedNotificationView: SpeedNotificationSuperView!
    
    var lastPosition:CLLocationCoordinate2D?
    var limitSpeed:Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationPermission()
        initGoogleMap()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        firebaseController = appDelegate.firebaseController
        
    }

//    @IBAction func testSound(_ sender: Any) {
//        let url = Bundle.main.url(forResource: "overspeed", withExtension: "wav")
//        do{
//            player =  try AVAudioPlayer(contentsOf: url!)
//            player.play()
//        }catch{
//            print(error)
//        }
//    }

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
        let speed = Int(fabs(locationInformation.speed * 3.6))
        speedAlertView.setCurrentSpeed(speed: String(format: "%d", speed))
        marker.position = locationInformation.coordinate
        let gmsCamera = GMSCameraPosition.camera(withLatitude: locationInformation.coordinate.latitude, longitude: locationInformation.coordinate.longitude, zoom: 19)
        mapview?.camera = gmsCamera
        
        //TODO 逻辑有问题
        if let lastPosition = lastPosition{
            requestMeasureTheSpeed(lastPosition: lastPosition, location: locationInformation)
        }else{
            lastPosition = locationInformation.coordinate
            if limitSpeed > 0 && speed > limitSpeed{

                //play an alert sound
                //play() method is already async
                let url = Bundle.main.url(forResource: "overspeed", withExtension: "wav")
                do{
                    player =  try AVAudioPlayer(contentsOf: url!)
                    player.play()
                }catch{
                    print(error)
                }

                self.recordOverSpeed(currentSpeed: speed, limitedSpeed: limitSpeed, location: locationInformation)
            }else if limitSpeed > 0{
                self.recordNormalSpeed(currentSpeed: Int(speed), limitedSpeed: limitSpeed, location: locationInformation)
            }
        }
    }
    
    func requestMeasureTheSpeed(lastPosition:CLLocationCoordinate2D, location:CLLocation){
        let coordinate = location.coordinate
        let left = lastPosition.longitude < coordinate.longitude ? lastPosition.longitude:coordinate.longitude
        let bottom = lastPosition.latitude < coordinate.latitude ? lastPosition.latitude:coordinate.latitude
        let right = lastPosition.longitude > coordinate.longitude ? lastPosition.longitude:coordinate.longitude
        let top = lastPosition.latitude > coordinate.latitude ? lastPosition.latitude:coordinate.latitude
        self.limitSpeed = 1

        let request = SpeedLimitRequest(left: left, right: right, top: top, bottom: bottom)
        request.RequestSpeedLimit(onCompleted: { [self](response) in
            if !response.ways.isEmpty{
                let way = response.ways[0]
                self.speedNotificationView.setSpeedNotification("\(way.speedMaxSpeed)")
                let speed = fabs(location.speed * 3.6)
                self.limitSpeed = Int(speed)
                if Int(speed) > way.speedMaxSpeed && way.speedMaxSpeed>0{

                    //play an alert sound
                    //play() method is already async
                    let url = Bundle.main.url(forResource: "overspeed", withExtension: "wav")
                    do{
                        self.player =  try AVAudioPlayer(contentsOf: url!)
                        self.player.play()
                    }catch{
                        print(error)
                    }

                    self.recordOverSpeed(currentSpeed: Int(speed), limitedSpeed: way.speedMaxSpeed, location: location)
                }else if way.speedMaxSpeed > 0{
                    self.recordNormalSpeed(currentSpeed: Int(speed), limitedSpeed: way.speedMaxSpeed, location: location)
                }
            }
        })
    }

    func recordOverSpeed(currentSpeed:Int, limitedSpeed:Int, location:CLLocation){
        print("Over speed is record speed limit is \(limitedSpeed), current speed is \(currentSpeed)")
        var overSpeedRecord = SpeedRecord(recordSpeed: currentSpeed, limitedSpeed: limitedSpeed, lat: location.coordinate.latitude, log: location.coordinate.longitude, roadName: "")
        let _ = firebaseController?.addOverSpeedRecord(overSpeedRecord)
    }
    
    func recordNormalSpeed(currentSpeed:Int, limitedSpeed:Int, location:CLLocation){
        print("normal speed is reocrded, limited speed is \(limitedSpeed), current speed is \(currentSpeed)")
        var normalSpeed = SpeedRecord(recordSpeed: currentSpeed, limitedSpeed: limitedSpeed, lat: location.coordinate.latitude, log: location.coordinate.longitude, roadName: "")
        let _ = firebaseController?.addOverSpeedRecord(normalSpeed)
    }
}
