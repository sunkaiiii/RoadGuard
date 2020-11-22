//
//  UITextFieldHelper.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import Foundation
import UIKit


extension UIViewController:UITextFieldDelegate{
    /// Provides a simple implementation of a retractable keyboard
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
