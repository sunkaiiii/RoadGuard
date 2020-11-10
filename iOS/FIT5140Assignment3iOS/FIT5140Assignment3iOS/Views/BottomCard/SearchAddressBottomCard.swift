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
    var areaOutlet: UIView?

    @IBOutlet weak var searchAddressBottomCardHandleAreaOutlet: UIView!

    @IBOutlet weak var searchAddressBottomCardTableViewOutlet: UITableView!
    
    @IBOutlet weak var searchAddressBar: UISearchBar!
    let locationManager = CLLocationManager.init()

    var realm : Realm?
    var searchAddressTimer:Timer?
    var currentSearchPlaceReqeust:SearchPlaceRequest?

    let SECTION_HEADER_SPECIFY = 0
    let SECTION_CONTENT_SPECIFY = 1
    let SECTION_HEADER_NEARBY = 2
    let SECTION_CONTENT_NEARBY = 3
    let DEFAULT_CELL_ID = "DefaultCell"
    let BOTTOM_CARD_CELL_ID = BottomCardSpecifyCell.identifier

    //根据需要展示的内容，更改数据类型和内容
    var tableViewDataSourceSpecify : [SearchPlaceDetail]  = []
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
        searchAddressBar.delegate = self
        searchAddressBar.searchTextField.delegate = self
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
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
    
    func requestSearchAddress(_ searchText:String)
    {
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
                handleNearByRoadResponse(nearestRoads)
            case .placeDetail:
                //decode JSON response
                guard let placeDetailResponse:PlaceDetailResponse = accessibleData.retriveData(helper: helper) else {
                    return
                }
                handlePlaceDetailResponse(placeDetailResponse)
            case .searchPlace:
                guard let searchPlaceResponse:SearchPlaceResponse = accessibleData.retriveData(helper: helper) else {
                    return
                }
                if helper.requestModel as? SearchPlaceRequest == currentSearchPlaceReqeust{
                    handleSearchPlaceResponse(searchPlaceResponse)
                }
            default:
                return
        }
    }

    func handleNearByRoadResponse(_ nearestRoads:NearestRoadResponse){
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
        //考虑for each循环完再reaload的话, case placeDetail 里是否还需要reaload,  以及这里会不会造成线程异步问题?
        //这里要不要把更新UI明确放在主线程？（不太清楚现在是什么线程）
        //after updating table view data source, reload table view
        searchAddressBottomCardTableViewOutlet.reloadData()
    }
    
    func handlePlaceDetailResponse(_ placeDetailResponse:PlaceDetailResponse){
        //这里要不要把存入数据库明确放入背景线程？（不太清楚现在是什么线程）
        //store into realm
        do{
            try realm?.write{
                realm?.add(placeDetailResponse.result!)
            }
        } catch {
            print(error)
        }

        //这里要不要把更新UI明确放在主线程？（不太清楚现在是什么线程）
        //attach into tableView and reload view
        self.tableViewDataSourceNearby.append(placeDetailResponse.result!)
        self.searchAddressBottomCardTableViewOutlet.reloadSections([SECTION_CONTENT_NEARBY], with: .automatic)
    }
    
    func handleSearchPlaceResponse(_ searchPlaceResponse:SearchPlaceResponse){
        tableViewDataSourceSpecify = searchPlaceResponse.results
        searchAddressBottomCardTableViewOutlet.reloadSections([SECTION_CONTENT_SPECIFY], with: .automatic)
    }
}




//
//func play(tag: Int){
//    //找到音频文件（类似于拿出一张CD光盘）-局部变量
//    let url = Bundle.main.url(forResource: sounds[tag-1], withExtension: "wav")
//
//    do{
//        player = try AVAudioPlayer(contentsOf: url!)//在CD机里面放入CD光盘
//        player.play()//按下播放按钮
//    }catch{
//        print(error)//放入的CD光盘可能有损坏导致CD机读不出来，我们需要用docatch来捕捉可能的错误，防止App闪退
//    }
//}

//从realm取数


//监听器方法，考虑放在哪
//            result.addNotificationBlock{
//                (changes:RealmColletionChange) in
//                //刷星数据库
//            }
//这个方法好像过时了


