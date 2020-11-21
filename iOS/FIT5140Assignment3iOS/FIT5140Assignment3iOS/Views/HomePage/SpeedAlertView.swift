//
//  SpeedAlertView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//


import UIKit

class SpeedAlertView: UIView {

    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedUnitLabel: UILabel!
    
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

    func setLabelFontSize(size:Int){
        speedLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(size))
        
        speedUnitLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(size - 3))

    }
}

enum SituationType {
    case overSpeed
    case safeSpeed
    case none
}
