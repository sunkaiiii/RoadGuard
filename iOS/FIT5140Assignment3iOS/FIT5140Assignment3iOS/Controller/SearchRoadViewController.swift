//
//  SearchRoadViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/25.
//

import UIKit
import GoogleMaps

class SearchRoadViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,DefaultHttpRequestAction,BottomCardSpeicifyCellDelegate {

    
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var selectMapItem: UIBarButtonItem!
    @IBOutlet weak var cancelItem: UIBarButtonItem!
    let SELECT_TEXT = "Select"
    let DONE_TEXT = "Done"
    let CANCEL_TEXT = "Cancel"
    let SAVE_ROAD_TEXT = "Save"
    let marker = GMSMarker()
    let locationManager = CLLocationManager.init()
    var selectMarkers:[GMSMarker] = []
    var selectedRoads:[RoadInformation] = []
    var snapPoints:[SnappedPointResponse] = []
    var backItem:UINavigationItem?
    var bottomContentView:UIView?
    var polyLine:GMSPolyline?
    override func viewDidLoad() {
        super.viewDidLoad()
        backItem = navigationController?.navigationBar.backItem
        initGoogleMap()
        initLocationManager()
        //initialise the BottomCard/FloatPanel
        setupBottomCard()
        //hiding the UIBarButtonItems, refrences on https://stackoverflow.com/questions/25492491/make-a-uibarbuttonitem-disappear-using-swift-ios
        cancelItem.isEnabled = false
    }
    func initGoogleMap(){
        marker.map = googleMapView
    }
    func initLocationManager(){
        
        locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation", completion: {
            error in
            if let error = error{
                print(error)
            }
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
        })

    }
    //using snap to road API, references on https://developers.google.com/maps/documentation/roads/snap
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first  else {
            return
        }
        self.locationManager.stopUpdatingLocation()
        let gmsCamera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18)
        googleMapView.camera = gmsCamera
        marker.position = location.coordinate
    }

    @IBAction func onSelectButtonClick(_ sender: Any) {
        if selectMapItem.title == SELECT_TEXT{
            selectMarkers.forEach({(markers) in markers.map = nil})
            selectMapItem.title = DONE_TEXT
            setBottomContentViewHidden(true)
            googleMapView.delegate = self
            marker.map = nil
            selectMarkers = []
            cancelItem.isEnabled = true
        }else if selectMapItem.title == DONE_TEXT{
            selectMapItem.title = SELECT_TEXT
            setBottomContentViewHidden(false)
            googleMapView.delegate = nil
            selectedRoads = []
            let points = selectMarkers.map({(marker)->CLLocationCoordinate2D in marker.position})
            selectMarkers.forEach({(marker) in marker.map = nil})
            if selectMarkers.count > 0{
                requestRestfulService(api: GoogleApi.snapToRoads, model: SnapToRoadsRequest(points: points), jsonType: SnapToRoadsResponse.self)
            }
        }else if selectMapItem.title == SAVE_ROAD_TEXT{
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, snapPoints.count > 0 else {
                return
            }
            let firebaseController = appDelegate.firebaseController
            let response = firebaseController?.addSelectedeRoad(UserSelectedRoadResponse(roadInformation:self.snapPoints))
            print(response ?? "")
            snapPoints = []
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelSelection(_ sender: Any) {
        if selectMapItem.title == DONE_TEXT{
            setBottomContentViewHidden(false)
        }
        selectMarkers.forEach({(markers) in markers.map = nil})
        selectMarkers = []
        selectedRoads = []
        snapPoints = []
        polyLine?.map = nil
        selectMapItem.title = SELECT_TEXT
        cancelItem.isEnabled = false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = googleMapView
        selectMarkers.append(marker)
    }
    
    //Hidden view with animition
    //References on https://stackoverflow.com/questions/36340595/uiview-slide-in-animation
    func setBottomContentViewHidden(_ isHidden:Bool){
        guard let contentView = bottomContentView else {
            return
        }
        UIView.transition(with: contentView, duration: 0.8, options: .curveLinear, animations: {
            if isHidden{
                contentView.frame.origin.y = contentView.frame.origin.y + 120
            }else{
                contentView.isHidden = isHidden
                contentView.frame.origin.y = contentView.frame.origin.y - 120
            }
        }, completion: {(completed) in contentView.isHidden = isHidden})
    }
    
    //draw a line in the google map view, references on the usage of javescript api https://developers.google.com/maps/documentation/roads/snap
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .snapToRoads:
            let response:SnapToRoadsResponse = accessibleData.retriveData()
            let points = response.snappedPoints
            drawPathIntoMap(points: points)
            self.snapPoints = points
        default:
            return
        }
    }
    
    
    func drawPathIntoMap(points:[SnappedPointResponse]){
        let path = GMSMutablePath()
        points.forEach({(point) in path.add(CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude))})
        polyLine = GMSPolyline(path: path)
        polyLine?.map = googleMapView
        selectMapItem.title = SAVE_ROAD_TEXT
    }
    

    func addRoad(roadInfo: RoadInformation) {
        selectedRoads.append(roadInfo)
        requestPathBySelectedRoads()
    }
    
    func removeRoad(roadInfo: RoadInformation) {
        guard let index = selectedRoads.firstIndex(where: {(road) in road.placeID == roadInfo.placeID}) else {
            return
        }
        selectedRoads.remove(at: index)
        requestPathBySelectedRoads()
    }
    
    func requestPathBySelectedRoads(){
        let points = selectedRoads.map({(road)->CLLocationCoordinate2D in CLLocationCoordinate2D(latitude: road.latitude, longitude: road.longitude)})
        requestRestfulService(api: GoogleApi.snapToRoads, model: SnapToRoadsRequest(points: points), jsonType: SnapToRoadsResponse.self)
    }

    // MARK: - BottomCard/FloatPanel Related functions
    func setupBottomCard(){
        let contentView = SearchAddressBottomCard(nibName:"SearchAddressBottomCard", bundle:nil)
        contentView.searchAddressDelegate = self
        let bototmScrollableViewController = BottomScrollableView(contentViewController: contentView, superview: self.view)
        bottomContentView = bototmScrollableViewController
        bototmScrollableViewController.cardHandleAreaHeight = self.view.frame.height / 5 + 15
        bototmScrollableViewController.cardHeight =  self.view.frame.height / 4 * 3
        self.view.addSubview(bototmScrollableViewController)
    }

}
