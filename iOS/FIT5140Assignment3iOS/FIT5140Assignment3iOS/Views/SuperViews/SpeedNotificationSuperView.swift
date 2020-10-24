//
//  SpeedNotificationSuperView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 25/10/20.
//

import UIKit

@IBDesignable class SpeedNotificationSuperView: BaseUIView,XibLoadedView {
    override func XibName() -> String {
        return "\(SpeedNotificationView.classForCoder().class())"
    }
}
