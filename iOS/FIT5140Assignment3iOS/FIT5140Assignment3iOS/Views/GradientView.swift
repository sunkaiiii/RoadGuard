//
//  GradientView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 19/11/20.
//

import Foundation
import UIKit

//Gradient colour background, references on https://medium.com/@sakhabaevegor/create-a-color-gradient-on-the-storyboard-18ccfd8158c2

@IBDesignable
class GradientView:UIView{
    @IBInspectable var firstColor: UIColor = UIColor.clear {
      didSet {
          updateView()
       }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
       didSet {
           updateView()
       }
   }
    
    @IBInspectable var angle: Int = 0 {
       didSet {
          updateView()
       }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        let angle = (self.angle*2)%360
        let startX = Double(angle)/360.0
        let endX = 1-Double(angle)/360.0
        layer.startPoint = CGPoint(x: startX, y: 0.5)
        layer.endPoint = CGPoint(x: endX, y: 1)
//        if (self.isHorizontal) {
//           layer.startPoint = CGPoint(x: 0, y: 0.5)
//           layer.endPoint = CGPoint (x: 1, y: 0.5)
//        } else {
//           layer.startPoint = CGPoint(x: 0.5, y: 0)
//           layer.endPoint = CGPoint (x: 0.5, y: 1)
//        }
    }
    
    override class var layerClass: AnyClass {
       get {
          return CAGradientLayer.self
       }
    }

}
