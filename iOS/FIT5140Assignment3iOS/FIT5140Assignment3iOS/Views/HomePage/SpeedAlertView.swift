//
//  SpeedAlertView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//


import UIKit

class SpeedAlertView: UIView {

    @IBOutlet weak var speedLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
        layer.masksToBounds = true
    }
    
    func setSpeedLabel(speed:String){
        speedLabel.text = speed
    }

    func setBackgroundColorBasingOnSituation(situation: SituationType){
        if situation == .overSpeed{
            self.backgroundColor = .red
        }
    }
}

enum SituationType {
    case overSpeed
    case safeSpeed
    case none
}
