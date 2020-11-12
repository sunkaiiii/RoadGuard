//
//  ImportantPatDetailViewControllerExtension.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 11/11/20.
//

import UIKit
import GoogleMaps

extension ImportantPathDetailViewController{
    func initViews(){
        importantPathTableView.layer.cornerRadius = 24
        importantPathGoogleMapView.layer.cornerRadius = 24
        let blurEffect = UIBlurEffect(style: .light)
        totalLengthVisualEffectView.effect = blurEffect
        passTimesVisualEffectView.effect = blurEffect
        visualEffectForTablViewBackground.effect = blurEffect
        visualEffectForTablViewBackground.layer.cornerRadius = 24
        visualEffectForTablViewBackground.contentView.layer.cornerRadius = 24
        visualEffectForTablViewBackground.clipsToBounds = true
        totalLengthVisualEffectView.layer.cornerRadius = 24
        totalLengthVisualEffectView.contentView.layer.cornerRadius = 24
        totalLengthVisualEffectView.clipsToBounds = true
        totalLengthVisualEffectView.contentView.clipsToBounds = true
        passTimesVisualEffectView.layer.cornerRadius = 24
        passTimesVisualEffectView.contentView.layer.cornerRadius = 24
        passTimesVisualEffectView.clipsToBounds = true
        passTimesVisualEffectView.contentView.clipsToBounds = true
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func initTopTableData(){
        guard let selectedRoad = selectedRoad else {
            return
        }
        var lastPlaceId:String = ""
        selectedRoad.selectedRoads.forEach{(road) in
            if road.placeID != lastPlaceId{
                roads.append(road.placeID)
            }
            lastPlaceId = road.placeID
        }
    }
    
    func initGoogleMap(){
        guard let selectedRoad = selectedRoad,let firstPlace = selectedRoad.selectedRoads.first else {
            return
        }
        let gmsCamera = GMSCameraPosition.init(latitude:firstPlace.location.latitude , longitude: firstPlace.location.longitude, zoom: 16)
        importantPathGoogleMapView.camera = gmsCamera
        let path = GMSMutablePath()
        selectedRoad.selectedRoads.forEach({(point) in path.add(CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude))})
        let polyLine = GMSPolyline(path: path)
        polyLine.map = importantPathGoogleMapView
        //rendering 2 decimal places for a double, references on https://www.codegrepper.com/code-examples/swift/swift+double+2+decimal+places
        totalLengthNumberLabel.text = String(format: "%.2f", path.length(of: .geodesic)/1000.0)
    }
}
