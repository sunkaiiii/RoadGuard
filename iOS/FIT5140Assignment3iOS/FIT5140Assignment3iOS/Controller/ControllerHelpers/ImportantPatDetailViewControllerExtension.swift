//
//  ImportantPatDetailViewControllerExtension.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 11/11/20.
//

import UIKit


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
    
    func initData(_ selectedRoad:UserSelectedRoadResponse?){
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
}
