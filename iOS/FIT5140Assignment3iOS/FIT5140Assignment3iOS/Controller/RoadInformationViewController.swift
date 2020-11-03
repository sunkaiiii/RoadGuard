//
//  RoadInformationViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

class RoadInformationViewController: UIViewController,DefaultHttpRequestAction {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        setupBottomCard()
    }
    
    //let the navigation bar fully transparent, references on https://stackoverflow.com/questions/25845855/transparent-navigation-bar-ios
    func initNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

    }
    
    func handleData(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        
    }

    // MARK: - BottomCard/FloatPanel Related functions
    func setupBottomCard() {
        let contentController = RoadInfoBottomCard(nibName:"RoadInfoBottomCard", bundle:nil)
        let bototmScrollableViewController = BottomScrollableView(contentViewController: contentController, superview: self.view)
        self.view.addSubview(bototmScrollableViewController)
    }

}
