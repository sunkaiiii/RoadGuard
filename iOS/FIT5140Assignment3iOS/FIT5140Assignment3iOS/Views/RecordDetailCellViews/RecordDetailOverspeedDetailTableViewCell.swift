//
//  RecordDetailOverspeedDetailTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 21/11/20.
//

import UIKit

class RecordDetailOverspeedDetailTableViewCell: UITableViewCell,DefaultHttpRequestAction {

    @IBOutlet weak var timeAndLocationLabel: UILabel!
    @IBOutlet weak var speedAndLimitSpeedLabel: UILabel!
    static let identifier = "RecordDetailOverspeedDetailTableViewCell"
    
    var placeName:String = ""
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailOverspeedDetailTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func initwithSpeedRecord(_ record:SpeedRecord){
        requestCachegableDataFromRestfulService(api: GoogleApi.nearestRoads, model: NearestRoadsRequest(lat: record.latitude, log: record.longitude), jsonType: NearestRoadResponse.self, cachegableHelper: NearestRoadResponseCacheHelper())
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        timeAndLocationLabel.text = formatter.string(from: record.recordTime)
        speedAndLimitSpeedLabel.text = "Speed is \(Int(record.currentSpeed)), Speed limit is \(Int(record.limitedSpeed))"
    }
    
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .nearestRoads:
            let road:NearestRoadResponse = accessibleData.retriveData()
            if road.snappedPoints.count > 0{
                let placeId = road.snappedPoints[0].placeID
                requestCachegableDataFromRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: placeId), jsonType: PlaceDetailResponse.self, cachegableHelper: PlaceDetailResponseCacheDataHelper())
            }
        case .placeDetail:
            let placeDetial:PlaceDetailResponse = accessibleData.retriveData()
            timeAndLocationLabel.text = "\(timeAndLocationLabel.text ?? "") at \(placeDetial.result.name)"
            self.placeName = placeDetial.result.name
        default:
            return
        }
    }
    
}
