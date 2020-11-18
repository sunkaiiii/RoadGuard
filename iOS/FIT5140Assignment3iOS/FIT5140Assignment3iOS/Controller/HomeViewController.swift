//
//  HomeViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import UIKit
import GoogleMaps


class HomeViewController: UIViewController,CLLocationManagerDelegate,DefaultHttpRequestAction {


    let manager = CLLocationManager.init()
    var mapview:GMSMapView?
    let marker = GMSMarker()
    var currentSpeed = -1
    var speedLimit = -1
    weak var firebaseController:DatabaseProtocol?
    @IBOutlet weak var speedAlertView: SpeedAlertSuperView!
    @IBOutlet weak var speedNotificationView: SpeedNotificationSuperView!
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!

    var lastPosition:CLLocationCoordinate2D?
    var limitSpeed:Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationPermission()
        initGoogleMap()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        firebaseController = appDelegate.firebaseController

        //to make the speed circle position dynamiclly adjusted on different size of screen
        bottomSpacingConstraint.constant = self.view.frame.height / 9
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
        marker.position = locationInformation.coordinate
        let gmsCamera = GMSCameraPosition.camera(withLatitude: locationInformation.coordinate.latitude, longitude: locationInformation.coordinate.longitude, zoom: 19)
        mapview?.camera = gmsCamera
        requestRestfulService(api: RaspberryPiApi.get_current_speed, model: DefaultSimpleGetModel(), jsonType: CurrentSpeedResponse.self)
    }
    
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? RaspberryPiApi{
        case .get_current_speed:
            let currentSpeedResponse:CurrentSpeedResponse = accessibleData.retriveData()
            speedAlertView.setCurrentSpeed(speed: String(format: "%d", currentSpeedResponse.speed))
            requestRestfulService(api: RaspberryPiApi.get_speed_limit, model: DefaultSimpleGetModel(), jsonType: SpeedLimitResponse.self)
        case .get_speed_limit:
            let speedLimitResponse:SpeedLimitResponse = accessibleData.retriveData()
            if !speedLimitResponse.isError{
                self.speedLimit = speedLimitResponse.speedLimit
                speedNotificationView.setSpeedNotification("\(self.speedLimit)")
                validateSpeed()
            }
        default:
            return
        }
    }
    
    func validateSpeed(){
        let currentSpeed = self.currentSpeed
        let speedLimit = self.speedLimit
        if currentSpeed > 0 && speedLimit > 0  {
            return
        }
        if currentSpeed > speedLimit{
            SoundHelper.shared.playOverSpeedSound()
        }
    }
}
