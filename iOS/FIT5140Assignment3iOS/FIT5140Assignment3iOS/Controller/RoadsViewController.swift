//
//  RoadsViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/25.
//

import UIKit
import GoogleMaps

class RoadsViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,DefaultHttpRequestAction {

    
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var selectMapItem: UIBarButtonItem!
    let SELECT_TEXT = "Select"
    let DONE_TEXT = "Done"
    let CANCEL_TEXT = "Cancel"
    let marker = GMSMarker()
    let locationManager = CLLocationManager.init()
    var selectMarkers:[GMSMarker] = []
    var backItem:UINavigationItem?
    var bottomContentView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        backItem = navigationController?.navigationBar.backItem
        initGoogleMap()
        initLocationManager()
        //initialise the BottomCard/FloatPanel
        setupBottomCard()
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
            selectMapItem.title = DONE_TEXT
            setBottomContentViewVisibility(true)
            googleMapView.delegate = self
            marker.map = nil
            selectMarkers = []
        }else if selectMapItem.title == DONE_TEXT{
            selectMapItem.title = SELECT_TEXT
            setBottomContentViewVisibility(false)
            googleMapView.delegate = nil
            let points = selectMarkers.map({(marker)->CLLocationCoordinate2D in marker.position})
            selectMarkers.forEach({(marker) in marker.map = nil})
            if selectMarkers.count > 0{
                requestRestfulService(api: GoogleApi.snapToRoads, model: SnapToRoadsRequest(points: points), jsonType: SnapToRoadsResponse.self)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = googleMapView
        selectMarkers.append(marker)
    }
    
    //Hidden view with animition
    //References on https://stackoverflow.com/questions/36340595/uiview-slide-in-animation
    func setBottomContentViewVisibility(_ isHidden:Bool){
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
    func handleData(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .snapToRoads:
            let response:SnapToRoadsResponse? = accessibleData.retriveData(helper: helper)
            guard let points = response?.snappedPoints else {
                return
            }
            let path = GMSMutablePath()
            points.forEach({(point) in path.add(CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude))})
            let polyline = GMSPolyline(path: path)
            polyline.map = googleMapView
        default:
            return
        }
    }
    
    // MARK: - BottomCard/FloatPanel Related functions
    func setupBottomCard(){
        let contentView = SearchAddressBottomCard(nibName:"SearchAddressBottomCard", bundle:nil)
        let bototmScrollableViewController = BottomScrollableView(contentViewController: contentView, superview: self.view)
        bottomContentView = bototmScrollableViewController
        bototmScrollableViewController.cardHandleAreaHeight = 180
        self.view.addSubview(bototmScrollableViewController)
    }
}
