//
//  SpeedAlertSuperView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 25/10/20.
//

import UIKit

@IBDesignable class SpeedAlertSuperView: BaseUIView,XibLoadedView{
    override func XibName() -> String {
        return "\(SpeedAlertView.classForCoder().class())"
    }
    
    func setCurrentSpeed(speed:String){
        (childView as? SpeedAlertView)?.setSpeedLabel(speed: speed)
    }
}

