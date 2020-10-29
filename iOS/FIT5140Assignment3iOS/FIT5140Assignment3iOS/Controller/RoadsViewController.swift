//
//  RoadsViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/25.
//

import UIKit
import GoogleMaps

class RoadsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initGoogleMap()
        //initialise the BottomCard/FloatPanel
        setupBottomCard()
    }
    
    func initGoogleMap(){
        let gmsCamera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapview = GMSMapView.map(withFrame: self.view.frame, camera: gmsCamera)
        self.view.addSubview(mapview)
    }
    
    func setupBottomCard(){
        let contentController = SearchAddressBottomCard(nibName:"SearchAddressBottomCard", bundle:nil)
        let bototmScrollableViewController = BottomScrollableView(contentViewController: contentController, superview: self.view)
        bototmScrollableViewController.cardHandleAreaHeight = 150
        self.view.addSubview(bototmScrollableViewController)
    }
}
