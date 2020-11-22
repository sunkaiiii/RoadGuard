//
//  EditRoadViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/11/20.
//

import UIKit
import GoogleMaps

class EditRoadViewController: UIViewController,DefaultHttpRequestAction,GMSMapViewDelegate,CustomRoadControllerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var drawControlBtn: UIBarButtonItem!

    var selectedRoad:UserSelectedRoadResponse?
    var polyLine:GMSPolyline?
    var snapPoints:[SnappedPointResponse]?
    var selectMarkers:[GMSMarker] = []
    var editRoadAlert:AddRoadNameAlertViewController?
    private let DONE = "Done"
    private let CLEAR = "Clear"
    private var hasAltered = false
    var delegate:EditRoadDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews(){
        guard let road = selectedRoad else {
            return
        }
        self.snapPoints = road.selectedRoads
        initBtnStatus()
        drawPath()
    }
    
    private func initBtnStatus(){
        if (snapPoints?.count ?? 0) > 0{
            saveBtn.isEnabled = true
            drawControlBtn.title = CLEAR
        }else{
            saveBtn.isEnabled = false
            drawControlBtn.title = DONE
        }
    }
    
    private func drawPath(){
        guard let points = self.snapPoints else {
            return
        }
        let path = GMSMutablePath()
        points.forEach({(point) in path.add(CLLocationCoordinate2D(latitude: point.location.latitude, longitude: point.location.longitude))})
        polyLine = GMSPolyline(path: path)
        polyLine?.map = mapView
        if points.count > 0 {
            let gmsCamera = GMSCameraPosition.camera(withLatitude: points[0].location.latitude, longitude: points[0].location.longitude, zoom: 18)
            mapView.camera = gmsCamera
        }
    }
    
    private func clearPath(){
        polyLine?.map = nil
        snapPoints?.removeAll()
        selectMarkers.forEach({(m) in m.map = nil})
        selectMarkers.removeAll()
    }
    
    //When adding roads, set a delegate for mapview.
    //Set the delgate of the mapview to nil at the end of the add.
    @IBAction func drawAction(_ sender: Any) {
        hasAltered = true
        if drawControlBtn.title == DONE{
            let points = selectMarkers.map({(marker)->CLLocationCoordinate2D in marker.position})
            if selectMarkers.count > 0{
                self.mapView.delegate = nil
                drawControlBtn.isEnabled = false
                clearPath()
                requestRestfulService(api: GoogleApi.snapToRoads, model: SnapToRoadsRequest(points: points), jsonType: SnapToRoadsResponse.self)
            }
        }else{
            clearPath()
            self.snapPoints?.removeAll()
            drawControlBtn.title = DONE
            self.mapView.delegate = self
            initBtnStatus()
        }
    }

    // MARK: - IBAction
    @IBAction func saveBtnAction(_ sender: Any) {
        editRoadAlert = AddRoadNameAlertViewController(delegate: self)
        editRoadAlert?.selectedRoad = self.selectedRoad
        if let alert = editRoadAlert{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Network Request Handler
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi{
        case .snapToRoads:
            let response:SnapToRoadsResponse = accessibleData.retriveData()
            let points = response.snappedPoints
            self.snapPoints = points
            self.drawControlBtn.isEnabled = true
            drawPath()
            initBtnStatus()
        default:
            return
        }
    }

    // MARK: - Google Map
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        selectMarkers.append(marker)
    }

    // MARK: - Firebase
    func didCustomFinished(customName: String, storedUrl: String) {
        if let databaseController = (UIApplication.shared.delegate as? AppDelegate)?.firebaseController, let id = selectedRoad?.id, let points = snapPoints, points.count > 0{
            if let newRoad = databaseController.editSelectedRoad(id, points: points, customName: customName, storedUrl: storedUrl){
                delegate?.roadDidEdited(newRoad: newRoad)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

protocol EditRoadDelegate {
    func roadDidEdited(newRoad:UserSelectedRoadResponse)
}
