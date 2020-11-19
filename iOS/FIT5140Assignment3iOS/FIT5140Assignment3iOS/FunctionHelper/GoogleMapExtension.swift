//
//  CustomGoogleMapView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 19/11/20.
//

import Foundation
import GoogleMaps

// dark mode style, referencces on https://developers.google.com/maps/documentation/ios-sdk/styling
extension GMSMapView{
    func changeToDarkMode(){
        do {
              // Set the map style by passing the URL of the local file.
              if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
              } else {
                NSLog("Unable to find style.json")
              }
            } catch {
              NSLog("One or more of the map styles failed to load. \(error)")
            }
    }
    
    func changeToLightMode(){
        self.mapStyle = nil
    }
    
    open override func didMoveToSuperview() {
        handleWithTheme()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *){
            // sense theme swtich references on https://engineering.nodesagency.com/categories/ios/2019/07/03/Dark-Mode
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
                handleWithTheme()
            }
        }
    }
    
    private func handleWithTheme(){
        if traitCollection.userInterfaceStyle == .dark{
            changeToDarkMode()
        }else{
            changeToLightMode()
        }
    }
}
