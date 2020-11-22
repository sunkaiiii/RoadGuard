//
//  SearchAddressBottomCard.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/24.
//

import Foundation
import UIKit
import MapKit
import RealmSwift

class SearchAddressBottomCard : UIViewController, UITableViewDelegate, UITableViewDataSource,ScrollableViewController,DefaultHttpRequestAction,CLLocationManagerDelegate,UISearchBarDelegate,UITextViewDelegate{

    @IBOutlet weak var searchAddressBottomCardHandleAreaOutlet: UIView!
    @IBOutlet weak var searchAddressBottomCardTableViewOutlet: UITableView!
    @IBOutlet weak var searchAddressBar: UISearchBar!
    var areaOutlet: UIView?
    let locationManager = CLLocationManager.init()
    var searchAddressTimer:Timer?
    var currentSearchPlaceReqeust:SearchPlaceRequest?
    let SECTION_HEADER_SPECIFY = 0
    let SECTION_CONTENT_SPECIFY = 1
    let SECTION_HEADER_NEARBY = 2
    let SECTION_CONTENT_NEARBY = 3
    let DEFAULT_CELL_ID = "DefaultCell"
    let BOTTOM_CARD_CELL_ID = BottomCardSpecifyCell.identifier
    var tableViewDataSourceSpecify : [SearchPlaceDetail]  = []
    var tableViewDataSourceNearby : [PlaceDetail] =  []
    var searchAddressDelegate:BottomCardSpeicifyCellDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.areaOutlet = searchAddressBottomCardHandleAreaOutlet
        searchAddressBottomCardTableViewOutlet.delegate = self
        searchAddressBottomCardTableViewOutlet.dataSource = self
        searchAddressBottomCardTableViewOutlet.register(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL_ID)
        searchAddressBottomCardTableViewOutlet.register(BottomCardSpecifyCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)

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

    // MARK: - TextField Delegate
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }

    // MARK: - search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let timer = searchAddressTimer{
            if timer.isValid{
                timer.invalidate()
            }
        }
        searchAddressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {(timer) in
            self.requestSearchAddress(searchText)
        } )
    }
    
    func requestSearchAddress(_ searchText:String){
        let request = SearchPlaceRequest(query: searchText)
        self.currentSearchPlaceReqeust = request
        requestRestfulService(api: GoogleApi.searchPlace, model: request, jsonType: SearchPlaceResponse.self)
    }

    // MARK: - core location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first  else {
            return
        }
        let nearestRoadRequest = NearestRoadsRequest(lat: location.coordinate.latitude, log: location.coordinate.longitude)
        requestRestfulService(api: GoogleApi.nearestRoads, model: nearestRoadRequest, jsonType: NearestRoadResponse.self)
    }

    // MARK: - tableView
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
            let detail = tableViewDataSourceSpecify[indexPath.row]
            cell.initWithSearchRestul(detail)
            cell.delegate = searchAddressDelegate
            return cell
        } else {
            //for nearby-content section
            let cell = tableView.dequeueReusableCell(withIdentifier: BOTTOM_CARD_CELL_ID, for: indexPath) as! BottomCardSpecifyCell
            let placeDetail = tableViewDataSourceNearby[indexPath.row]
            cell.initWithPlaceDetail(placeDetail)
            cell.delegate = searchAddressDelegate
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

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at:indexPath,animated:true)
    }

    // MARK: - Network Request
    //action after request execution 
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
            case .nearestRoads:
                let nearestRoads:NearestRoadResponse = accessibleData.retriveData()
                handleNearByRoadResponse(nearestRoads)
            case .placeDetail:
                let placeDetailResponse:PlaceDetailResponse = accessibleData.retriveData()
                handlePlaceDetailResponse(placeDetailResponse)
            case .searchPlace:
                let searchPlaceResponse:SearchPlaceResponse = accessibleData.retriveData()
                if helper.requestModel as? SearchPlaceRequest == currentSearchPlaceReqeust{
                    handleSearchPlaceResponse(searchPlaceResponse)
                }
            default:
                return
        }
    }

    func handleNearByRoadResponse(_ nearestRoads:NearestRoadResponse){
        locationManager.stopUpdatingLocation()
        self.tableViewDataSourceNearby.removeAll()
        nearestRoads.snappedPoints.forEach({(points) in
            requestCachegableDataFromRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: points.placeID), jsonType: PlaceDetailResponse.self, cachegableHelper: PlaceDetailResponseCacheDataHelper())
        })
    }
    
    func handlePlaceDetailResponse(_ placeDetailResponse:PlaceDetailResponse){
        self.tableViewDataSourceNearby.append(placeDetailResponse.result)
        self.searchAddressBottomCardTableViewOutlet.reloadSections([SECTION_CONTENT_NEARBY], with: .automatic)
    }
    
    func handleSearchPlaceResponse(_ searchPlaceResponse:SearchPlaceResponse){
        tableViewDataSourceSpecify = searchPlaceResponse.results
        searchAddressBottomCardTableViewOutlet.reloadSections([SECTION_CONTENT_SPECIFY], with: .automatic)
    }
}




