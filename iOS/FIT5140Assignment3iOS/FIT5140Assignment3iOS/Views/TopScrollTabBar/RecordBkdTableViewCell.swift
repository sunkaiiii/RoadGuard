//
//  RecordBkdTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/31.
//

import UIKit

class RecordBkdTableViewCell: UITableViewCell,DefaultHttpRequestAction {
    @IBOutlet weak var iconImageOutlet: UIImageView!
    @IBOutlet weak var backgroundBorderAndColorViewOutlet: UIView!
    @IBOutlet weak var distanceLabelOutlet: UILabel!
    @IBOutlet weak var drivingTimeLabelOutlet: UILabel!    
    @IBOutlet weak var startAndEndPlaceLabelOutlet: UILabel!
    
    var startLocationPlaceId = ""
    var endLocationPlaceId = ""
    
    var startLocation = ""
    var endLocation = ""
    
    static let identifier = "RecordBkdTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordBkdTableViewCell", bundle: nil)
    }

    public func initWithData(_ record:DrivingRecordResponse){
        self.distanceLabelOutlet.text = String(format: "%.0f", record.drivingDistance) + "m"
        self.drivingTimeLabelOutlet.text = "Driving " + String(format: "%.0f", record.endTime.timeIntervalSince(record.startTime)/60) + "min"
        initDetailLabel()
        let lats = [record.startLocation.latitude,record.endLocation.latitude]
        let logs = [record.startLocation.logitude,record.endLocation.logitude]
        let nearestRoadRequest = NearestRoadsRequest(lat: lats, log: logs)
        requestCachegableDataFromRestfulService(api: GoogleApi.nearestRoads, model: nearestRoadRequest, jsonType: NearestRoadResponse.self, cachegableHelper: NearestRoadResponseCacheHelper())
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageOutlet.contentMode = .scaleAspectFit
        backgroundBorderAndColorViewOutlet.layer.cornerRadius = 24
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .nearestRoads:
            walkThourghNearestRodsPoint(roads: accessibleData.retriveData())
        case .placeDetail:
            handlePlaceDetailResponse(response: accessibleData.retriveData())
        default:
            return
        }
    }
    
    
    private func walkThourghNearestRodsPoint(roads:NearestRoadResponse){
        roads.snappedPoints.forEach({(point) in
            if point.originalIndex == 0{
                startLocationPlaceId = point.placeID
            }
            else{
                endLocationPlaceId = point.placeID
            }
            requestCachegableDataFromRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: point.placeID), jsonType: PlaceDetailResponse.self, cachegableHelper: PlaceDetailResponseCacheDataHelper())
        })
    }
    
    private func handlePlaceDetailResponse(response:PlaceDetailResponse){
        if response.result.placeID == startLocationPlaceId{
            self.startLocation = response.result.name
        }
        else if response.result.placeID == endLocationPlaceId{
            self.endLocation = response.result.name
        }
        
        initDetailLabel()
    }
    
    private func initDetailLabel(){
        self.startAndEndPlaceLabelOutlet.text = "From \(self.startLocation) to \(self.endLocation)"
    }
}
