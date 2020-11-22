//
//  SpeedLimitView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

///The bound of the view will be a circle
@IBDesignable class CircleShapeView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
        layer.masksToBounds = true
    }
}
