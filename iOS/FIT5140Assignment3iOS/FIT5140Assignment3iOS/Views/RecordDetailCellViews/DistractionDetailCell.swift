//
//  DistractionDetailCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/13.
//

import UIKit

class DistractionDetailCell: UITableViewCell,DefaultHttpRequestAction {
    
    @IBOutlet weak var timeAndLocationLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    
    static let identifier = "DistractionDetailCell"
    static func nib()->UINib{
        return UINib(nibName: "DistractionDetailCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initDistractionDetail(_ facialInfo:FacialInfo){
        emotionLabel.text = "Show \(facialInfo.faceDetails[0].emotions[0].type)"
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        timeAndLocationLabel.text = formatter.string(from: facialInfo.capturedTime)
        if let location = facialInfo.locationInfo, let lat = location.latitude,let log = location.longitude {
            requestCachegableDataFromRestfulService(api: GoogleApi.nearestRoads, model: NearestRoadsRequest(lat: lat, log:log ), jsonType: NearestRoadResponse.self, cachegableHelper: NearestRoadResponseCacheHelper())
        }

    }
    
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .nearestRoads:
            let roads:NearestRoadResponse = accessibleData.retriveData()
            if roads.snappedPoints.count > 0{
                let place = roads.snappedPoints[0].placeID
                requestCachegableDataFromRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: place), jsonType: PlaceDetailResponse.self, cachegableHelper: PlaceDetailResponseCacheDataHelper())
            }
        case .placeDetail:
            let placeDetail:PlaceDetailResponse = accessibleData.retriveData()
            timeAndLocationLabel.text = "\(timeAndLocationLabel.text ?? "") at \(placeDetail.result.name)"
        default:
            return
        }
    }
}
