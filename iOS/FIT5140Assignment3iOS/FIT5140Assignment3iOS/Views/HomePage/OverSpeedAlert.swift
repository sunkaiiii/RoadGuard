//
//  OverSpeedAlert.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 20/11/20.
//

import UIKit

class OverSpeedAlert: UIView {

    @IBOutlet weak var speedLimitLabel: UILabel!
    @IBOutlet weak var currentSpeed: SpeedAlertSuperView!
    
    
    // display a full screen alert, references on https://stackoverflow.com/questions/39586656/how-can-i-present-uiview-xib-as-alert-view-in-swift/39586736#39586736
    func showAlertView(currentSpeed:Int, limitedSpeed:Int){
        let windows = UIApplication.shared.windows
        let lastWindow = windows.last
        self.frame = UIScreen.main.bounds
        speedLimitLabel.text = "\(limitedSpeed)"
        speedLimitLabel.textColor = .black
        self.currentSpeed.setCurrentSpeed(speed: "\(currentSpeed)")
        self.alpha = 0
        lastWindow?.addSubview(self)
        UIView.animate(withDuration: 1, animations: {() in
            self.alpha = 1
        },completion: {(ok) in self.alpha = 1})
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {(timer) in
            UIView.animate(withDuration: 1, animations: {() in
                self.alpha = 0
                
            },completion: {(ok) in self.removeFromSuperview()})
            
            
        })
        
    }
    
}
