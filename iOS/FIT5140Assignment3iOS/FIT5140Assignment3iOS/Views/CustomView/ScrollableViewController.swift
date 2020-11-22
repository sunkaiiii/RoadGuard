//
//  ScrollableView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 29/10/20.
//

import UIKit

//This protocol is used for defining the bottom card handling area instance
protocol ScrollableViewController:UIViewController{
    var areaOutlet:UIView? {get}
}
