//
//  SpeedNotificationView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

class SpeedNotificationView: UIView {
    @IBOutlet weak var speedNotification: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 73)
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.7
        layer.cornerRadius = bounds.size.width/2
    }
    
    func setSpeedNotification(_ speed:String){
        speedNotification.text = speed
    }
}
