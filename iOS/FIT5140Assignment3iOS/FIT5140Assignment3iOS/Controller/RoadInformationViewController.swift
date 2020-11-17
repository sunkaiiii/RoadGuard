//
//  RoadInformationViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit

class RoadInformationViewController: UIViewController,DefaultHttpRequestAction , RoadInfoBottomCardDelegate{

    let DETAIL_PAGE_SEGUE_ID = "importantPathsSegue"
    
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
    
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        
    }

    // MARK: - BottomCard/FloatPanel Related functions
    func setupBottomCard() {
        let contentController = RoadInfoBottomCard(nibName:"RoadInfoBottomCard", bundle:nil)
        let bototmScrollableViewController = BottomScrollableView(contentViewController: contentController, superview: self.view)
//        self.addChild(contentController)
        bototmScrollableViewController.cardHandleAreaHeight = self.view.frame.height / 2.5
        bototmScrollableViewController.cardHeight =  self.view.frame.height / 4 * 3
        self.view.addSubview(bototmScrollableViewController)
        contentController.delegateParent = self
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DETAIL_PAGE_SEGUE_ID {
            if let des = segue.destination as? ImportantPathDetailViewController{
                des.selectedRoad = sender as? UserSelectedRoadResponse
            }

        }
    }


    // MARK: - RoadInfoBottomCardDelegate
    func jumpToSelectedRowDetailPage(selectedRow: UserSelectedRoadResponse) {
        performSegue(withIdentifier: DETAIL_PAGE_SEGUE_ID, sender: selectedRow)
    }

}
