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

class SearchAddressBottomCard : UIViewController, UITableViewDelegate, UITableViewDataSource,ScrollableViewController,DefaultHttpRequestAction,CLLocationManagerDelegate{
    var areaOutlet: UIView?

    @IBOutlet weak var searchAddressBottomCardHandleAreaOutlet: UIView!

    @IBOutlet weak var searchAddressBottomCardTableViewOutlet: UITableView!
    let locationManager = CLLocationManager.init()

    var realm : Realm?

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

        realm = (UIApplication.shared.delegate as! AppDelegate).realm

        locationManager.delegate = self
        locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation", completion: {
            error in
            if let error = error{
                print(error)
            }
            self.locationManager.startUpdatingLocation()
        })
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
            //这里需要根据传入的数据，给cell的控件赋值
            //            cell.iconImageView.image = UIImage(systemName: "mappin.circle.fill")
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

    // MARK: - Network Request
    //action after request execution 
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

                let results = realm?.objects(PlaceDetail.self)

                //first fetch data from Realm DB, if not exist, then make a Network Request
                nearestRoads.snappedPoints.forEach({(points) in
                    let predicate = NSPredicate(format: "placeID = %@",points.placeID)
                    let oneResult = results!.filter(predicate).first
                    if oneResult != nil {
                        self.tableViewDataSourceNearby.append(oneResult!)
                    }else {
                        requestRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: points.placeID), jsonType: PlaceDetailResponse.self)
                    }
                })
                
                //after updating table view data source, reload table view
                searchAddressBottomCardTableViewOutlet.reloadData()

            case .placeDetail:
                //decode JSON response
                guard let placeDetailResponse:PlaceDetailResponse = accessibleData.retriveData(helper: helper) else {
                    return
                }

                //store into realm
                do{
                    try realm?.write{
                        realm?.add(placeDetailResponse.result!)
                    }
                } catch {
                    print(error)
                }

                //attach into tableView and reload view
                self.tableViewDataSourceNearby.append(placeDetailResponse.result!)
                self.searchAddressBottomCardTableViewOutlet.reloadSections([SECTION_CONTENT_NEARBY], with: .automatic)
            default:
                return
        }
    }

}



//从realm取数


//监听器方法，考虑放在哪
//            result.addNotificationBlock{
//                (changes:RealmColletionChange) in
//                //刷星数据库
//            }
//这个方法好像过时了


