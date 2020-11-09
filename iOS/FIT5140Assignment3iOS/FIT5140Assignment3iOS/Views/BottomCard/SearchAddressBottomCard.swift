//
//  SearchAddressBottomCard.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/24.
//

import Foundation
import UIKit
import MapKit

class SearchAddressBottomCard : UIViewController, UITableViewDelegate, UITableViewDataSource,ScrollableViewController,DefaultHttpRequestAction,CLLocationManagerDelegate,UISearchBarDelegate,UITextViewDelegate{
    var areaOutlet: UIView?

    @IBOutlet weak var searchAddressBottomCardHandleAreaOutlet: UIView!

    @IBOutlet weak var searchAddressBottomCardTableViewOutlet: UITableView!
    
    @IBOutlet weak var searchAddressBar: UISearchBar!
    let locationManager = CLLocationManager.init()

    let SECTION_HEADER_SPECIFY = 0
    let SECTION_CONTENT_SPECIFY = 1
    let SECTION_HEADER_NEARBY = 2
    let SECTION_CONTENT_NEARBY = 3
    let DEFAULT_CELL_ID = "DefaultCell"
    let BOTTOM_CARD_CELL_ID = BottomCardSpecifyCell.identifier

    //根据需要展示的内容，更改数据类型和内容
    var tableViewDataSourceSpecify : [String]  = ["d","e","f"]
    var tableViewDataSourceNearby : [PlaceDetail] =  []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.areaOutlet = searchAddressBottomCardTableViewOutlet
        searchAddressBottomCardTableViewOutlet.delegate = self
        searchAddressBottomCardTableViewOutlet.dataSource = self
        searchAddressBottomCardTableViewOutlet.register(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL_ID)
        searchAddressBottomCardTableViewOutlet.register(BottomCardSpecifyCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)
        //        searchAddressBottomCardTableViewOutlet.register(UINib(nibName: "nibFileName", bundle: nil), forCellReuseIdentifier: "CellFromNib")
        locationManager.delegate = self
        locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation", completion: {
            error in
            if let error = error{
                print(error)
            }
            self.locationManager.startUpdatingLocation()
        })
        searchAddressBar.delegate = self
        searchAddressBar.searchTextField.delegate = self
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats:false, block: {(timer) in } )
    }


    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first  else {
            return
        }
        let nearestRoadRequest = NearestRoadsRequest(lat: location.coordinate.latitude, log: location.coordinate.longitude)
        requestRestfulService(api: GoogleApi.nearestRoads, model: nearestRoadRequest, jsonType: NearestRoadResponse.self)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
            case SECTION_HEADER_SPECIFY:
                return 1
            case SECTION_CONTENT_SPECIFY:
                return tableViewDataSourceSpecify.count
            case SECTION_HEADER_NEARBY:
                return 1
            case SECTION_CONTENT_NEARBY:
                return tableViewDataSourceNearby.count
            default:
                return 1
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_HEADER_SPECIFY {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "Specify"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            return cell
        }
        else if indexPath.section == SECTION_HEADER_NEARBY {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.textLabel?.text = "Nearby"
            return cell
        } else if indexPath.section == SECTION_CONTENT_SPECIFY {
            let cell = tableView.dequeueReusableCell(withIdentifier: BOTTOM_CARD_CELL_ID, for: indexPath) as! BottomCardSpecifyCell
            //调用cell.configure给图片和label赋值
            cell.iconImageView.image = UIImage(systemName: "mappin.circle.fill")
            return cell
        } else {
            //for nearby-content section
            let cell = tableView.dequeueReusableCell(withIdentifier: BOTTOM_CARD_CELL_ID, for: indexPath) as! BottomCardSpecifyCell
            let placeDetail = tableViewDataSourceNearby[indexPath.row]
            cell.initWithPlaceDetail(placeDetail)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_HEADER_SPECIFY {
            return 50
        } else if indexPath.section == SECTION_HEADER_NEARBY {
            return 50
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_HEADER_SPECIFY || indexPath.section == SECTION_HEADER_NEARBY{
            return false
        }
        return true
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_HEADER_SPECIFY || indexPath.section == SECTION_HEADER_NEARBY{
            searchAddressBottomCardTableViewOutlet.deselectRow(at:indexPath,animated:true)}
    }
    
    func handleData(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .nearestRoads:
            guard let nearestRoads:NearestRoadResponse = accessibleData.retriveData(helper: helper) else {
                return
            }
            //TODO place id对比
            locationManager.stopUpdatingLocation()
            //Todo 刷新位置按钮
            self.tableViewDataSourceNearby.removeAll()
            //TODO search cache if the detail is exists
            
            //else reqeust network
            nearestRoads.snappedPoints.forEach({(points) in
                requestRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: points.placeID), jsonType: PlaceDetailResponse.self)
            })
            
        case .placeDetail:
            guard let placeDetail:PlaceDetailResponse = accessibleData.retriveData(helper: helper) else {
                return
            }
            //TODO add detail into core data
            self.tableViewDataSourceNearby.append(placeDetail.result)
            self.searchAddressBottomCardTableViewOutlet.reloadSections([SECTION_CONTENT_NEARBY], with: .automatic)
        default:
            return
        }
    }

}






