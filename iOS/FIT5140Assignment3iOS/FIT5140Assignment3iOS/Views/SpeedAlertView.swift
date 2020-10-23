//
//  SpeedAlertView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//


import UIKit

@IBDesignable class SpeedAlertView: BaseUIView {
    @IBOutlet weak var speedLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
        layer.masksToBounds = true
    }
}
