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
    }
    
    func initTopTableData(){
        guard let selectedRoad = selectedRoad else {
            return
        }
        var roads:[String] = []
        var lastPlaceId:String = ""
        selectedRoad.selectedRoads.forEach{(road) in
            if road.placeID != lastPlaceId{
                roads.append(road.placeID)
            }
            lastPlaceId = road.placeID
        }
        if roads.count == 0 || selectedRoad.selectedRoads.count == 0{
            return
        }
        //The data exists as points in the firestore and may contain successive placeid, e.g. 1, 1, 1, 2, 2, 2, 3, 3
        //The following operation removes all duplicate placeid and preserves the original order to ensure the accuracy of the calculations.
        var i = 0
        var j = 0
        var path = GMSMutablePath()
        while(i<selectedRoad.selectedRoads.count){
            let point = selectedRoad.selectedRoads[i]
            if roads[j] == point.placeID{
                path.add(CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude))
            }else{
                roadsInfo.append(RoadInformationDataSource(placeId: roads[j], length: path.length(of: .geodesic)))
                j += 1
                path = GMSMutablePath()
                path.add(CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude))
            }
            i += 1
        }
        roadsInfo.append(RoadInformationDataSource(placeId: roads[j], length: path.length(of: .geodesic)))
    }
    
    func initGoogleMap(){
        guard let selectedRoad = selectedRoad,let firstPlace = selectedRoad.selectedRoads.first else {
            return
        }
        let gmsCamera = GMSCameraPosition.init(latitude:firstPlace.location.latitude , longitude: firstPlace.location.longitude, zoom: 16)
        importantPathGoogleMapView.camera = gmsCamera
        let path = GMSMutablePath()
        selectedRoad.selectedRoads.forEach({(point) in path.add(CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude))})
        polyLine?.map = nil
        polyLine = GMSPolyline(path: path)
        polyLine?.map = importantPathGoogleMapView
        //rendering 2 decimal places for a double, references on https://www.codegrepper.com/code-examples/swift/swift+double+2+decimal+places
        totalLengthNumberLabel.text = String(format: "%.2f", path.length(of: .geodesic)/1000.0)
    }
    
    //Each repeated crossing in a drivingRecord is considered to be 1, so passedtime will not be more than the current number of drivingRecords.
    func calculatePassedTime(){
        guard let selecterRoad = selectedRoad?.id, let firebaseController = (UIApplication.shared.delegate as? AppDelegate)?.firebaseController else {
            return
        }
        var calculateSet:[String] = []
        let drivingRecordList = firebaseController.getAllDrivingRecord()
        drivingRecordList.forEach({(record) in
            if let id = record.id{
                let facialList = firebaseController.getFacialRecordByRecordId(id)
                if facialList.contains(where: {(facial) in facial.selectedRoadIds?.contains(selecterRoad) ?? false}){
                    calculateSet.append(id)
                }
            }
        })
        passTimesLabel.text = "\(calculateSet.count)"
    }
}


