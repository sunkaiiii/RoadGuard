//
//  ImportantPathTableViewContentCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/10.
//

import UIKit

class ImportantPathTableViewContentCell: UITableViewCell,DefaultHttpRequestAction {

    

    @IBOutlet weak var roadNameLabel: UILabel!
    @IBOutlet weak var meterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleWithPlaceId(_ road:RoadInformationDataSource){
        requestRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: road.placeId), jsonType: PlaceDetailResponse.self)
        meterLabel.text = String(format: "%.0f", road.length)+"M"
    }
    
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        if let api = helper.restfulAPI as? GoogleApi, api == .placeDetail {
            let placeDetailResponse:PlaceDetailResponse = accessibleData.retriveData()
            let placeDetail = placeDetailResponse.result
            roadNameLabel.text = placeDetail.name
        }
    }

}
