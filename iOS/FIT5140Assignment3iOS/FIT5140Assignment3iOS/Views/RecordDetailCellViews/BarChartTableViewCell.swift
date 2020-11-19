//
//  BarChartTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/16.
//

import UIKit

class BarChartTableViewCell: UITableViewCell,DefaultHttpRequestAction {
    static let identifier = "BarChartTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "BarChartTableViewCell", bundle: nil)
    }

    @IBOutlet weak var backgroundVisualEffect: UIVisualEffectView!
    
    @IBOutlet weak var streetNameLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var barWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initBarChartCell(_ data:(String,Int)){
        let maxPossibleSpeed = CGFloat(360)
        let speed = CGFloat(data.1)
        let widthRatio = speed/maxPossibleSpeed
        backgroundVisualEffect.layer.cornerRadius = (self.layer.bounds.height-16)/2
        let baseWidth = CGFloat(130)
        let totalGapWidth = CGFloat(110)

        if speed == CGFloat(0) {
            barWidthConstraint.constant = baseWidth
        } else {
            barWidthConstraint.constant = baseWidth + (self.frame.width - baseWidth - totalGapWidth) * widthRatio
        }

        //we don't use CGFloat result here
        speedLabel.text =  "\(data.1)km/h"
        
        requestCachegableDataFromRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: data.0), jsonType: PlaceDetailResponse.self
                                                , cachegableHelper: PlaceDetailResponseCacheDataHelper())
    }
    
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .placeDetail:
            let response:PlaceDetailResponse = accessibleData.retriveData()
            streetNameLabel.text = response.result.name
            
        default:
            return
        }
    }
}
