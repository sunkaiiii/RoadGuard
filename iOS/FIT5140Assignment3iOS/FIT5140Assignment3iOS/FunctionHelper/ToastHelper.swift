//
//  ToastHelper.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation
import UIKit

extension UIViewController{
    /// In the lower part of the page, a text for a reminder is displayed
    /// references on https://www.xspdf.com/help/50710991.html
    func showToast(message : String, font: UIFont = .systemFont(ofSize: 14.0)) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-150, width: 300, height: heightForView(text: message, font: font, width: 300)))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 10;
        toastLabel.numberOfLines = 50
        toastLabel.clipsToBounds  =  true
        toastLabel.alpha = 0
        self.view.addSubview(toastLabel)
        self.view.bringSubviewToFront(toastLabel)
        UIView.animate(withDuration: 0.5, animations: {() in
            toastLabel.alpha = 1
        },completion: {(ok) in toastLabel.alpha = 1})
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {(timer) in
            UIView.animate(withDuration: 2, animations: {() in
                toastLabel.alpha = 0
                
            },completion: {(ok) in toastLabel.removeFromSuperview()})
            
        })
    }
    
    // Adjust label height, references on https://stackoverflow.com/questions/25180443/adjust-uilabel-height-to-text
    private  func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 50
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        label.layer.cornerRadius = 10;
        label.clipsToBounds  =  true
        return label.frame.height*1.5
    }
}
