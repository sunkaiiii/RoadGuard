//
//  DistractionSpeedLimitSuperView.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/13.
//

import Foundation
import UIKit

@IBDesignable  class DistractionSpeedLimitSuperView : BaseUIView,XibLoadedView {
    override func XibName() -> String {
        return "\(DistractionSpeedInfoView.classForCoder().class())"
    }

}
