//
//  HomeViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {

    @IBOutlet weak var speedNotificationView: SpeedNotificationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gmsCamera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapview = GMSMapView.map(withFrame: self.view.frame, camera: gmsCamera)
        self.view.addSubview(mapview)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapview
    }

}
