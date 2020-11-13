//
//  DistractionSpeedLimitInfoView.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/13.
//

import UIKit

class DistractionSpeedLimitInfoView: UIView {

    @IBOutlet weak var speedLImitLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setSpeedLimit(_ speed:String){
        speedLImitLabel.text = speed
    }
}
