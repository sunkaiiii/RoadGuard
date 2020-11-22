//
//  RoadInformationViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//

import UIKit
import GoogleMaps

class RoadInformationViewController: UIViewController,DefaultHttpRequestAction , RoadInfoBottomCardDelegate{

 
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var roadsCountLabel: UILabel!
    
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
        bototmScrollableViewController.tabBarHeight = (self.tabBarController?.tabBar.frame.height) ?? 0
        contentController.askDelegateToCalculateTotalNumberAndDistance()
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

    func calculateTotalNumberAndDistance(roadRecords: [UserSelectedRoadResponse]){

        func calculatePathLength(roadRecord: UserSelectedRoadResponse)->Double{
            var lastPlaceId:String = ""
            let path = GMSMutablePath()
            roadRecord.selectedRoads.forEach{(road) in
                if road.placeID != lastPlaceId{
                    path.add(CLLocationCoordinate2D(latitude: road.location.latitude, longitude: road.location.longitude))
                }
                lastPlaceId = road.placeID
            }
            return path.length(of: .geodesic)
        }

        var lengthTotal = 0.0
        var selectedRoadsCount = 0
        for record in roadRecords{
            lengthTotal = lengthTotal + calculatePathLength(roadRecord: record)
            selectedRoadsCount += record.selectedRoads.count
        }
        roadsCountLabel.text = "\(selectedRoadsCount)"
        totalDistanceLabel.text = "Total Length: \((lengthTotal/1000).rounded(.up)) KM"
        
    }

}
