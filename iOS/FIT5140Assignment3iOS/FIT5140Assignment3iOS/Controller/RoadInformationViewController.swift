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
        setupBottomCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        restoreNavigationBar()
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
