//
//  NavigationBarHelper.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/11/20.
//

import UIKit


extension UIViewController{
    //let the navigation bar fully transparent, references on https://stackoverflow.com/questions/25845855/transparent-navigation-bar-ios
    func initNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

    }
    
    func restoreNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .systemBackground
    }
}
