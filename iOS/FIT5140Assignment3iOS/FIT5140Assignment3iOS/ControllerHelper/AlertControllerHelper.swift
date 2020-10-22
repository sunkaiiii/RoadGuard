//
//  AlertControllerHelper.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showAltert(title:String, message:String?){
        let altertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        altertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(altertController, animated: true, completion: nil)
    }
}
