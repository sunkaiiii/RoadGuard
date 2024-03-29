//
//  BottomCardImportantRoadCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/25.
//

import UIKit

class BottomCardImportantRoadCell: UITableViewCell,DefaultHttpRequestAction {

    
    @IBOutlet weak var iconImageView : UIImageView!
    @IBOutlet weak var headerLabel : UILabel!
    @IBOutlet weak var fromLabel : UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var distanceLabel : UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!

    var firstPoint:SnappedPointResponse?
    var lastPoint:SnappedPointResponse?
    var startName:String?
    var endName:String?
    private var imageUrl:String = ""
    static let identifier = "BottomCardImportantRoadCell"
    static func nib()->UINib{
        return UINib(nibName: "BottomCardImportantRoadCell", bundle: nil)
    }
    
    func initWithSelectedRoadData(_ selectedRoad:UserSelectedRoadResponse){
        self.headerLabel.text = selectedRoad.selectedRoadCustomName
        self.imageUrl = selectedRoad.userCustomImage ?? ""
        //Take the first and last points to form from and to
        if selectedRoad.selectedRoads.count > 0{
            firstPoint = selectedRoad.selectedRoads.first
            lastPoint = selectedRoad.selectedRoads.last
            guard let first = firstPoint, let last = lastPoint else {
                return
            }
            // Because the coordinates are accessed, the interface needs to be called to obtain the placeId
            requestCachegableDataFromRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: first.placeID), jsonType: PlaceDetailResponse.self, cachegableHelper: PlaceDetailResponseCacheDataHelper())
            requestCachegableDataFromRestfulService(api: GoogleApi.placeDetail, model: PlaceDetailRequest(placeId: last.placeID), jsonType: PlaceDetailResponse.self, cachegableHelper: PlaceDetailResponseCacheDataHelper())
        }
        if self.imageUrl.count>0{
            ImageLoader.simpleLoad(self.imageUrl, onComplete: {(url,image) in
                self.iconImageView.image = image?.circleMasked
            })
        }
    }
    


    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.contentMode = .scaleAspectFit
        backgroundColorView.layer.cornerRadius = 18
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .placeDetail:
            let response:PlaceDetailResponse = accessibleData.retriveData()
            initContentLabel(response)
        default:
            return
        }
    }
    
    func initContentLabel(_ placeDetail:PlaceDetailResponse){
        let refreshContentLabel = {() in
            self.fromLabel.text = "From: \(self.startName ?? "")"
            self.toLabel.text = "To \(self.endName ?? "")"
        }
        if placeDetail.result.placeID == firstPoint?.placeID{
            startName = placeDetail.result.name
            if self.imageUrl.count == 0{
                self.imageUrl = placeDetail.result.icon
                ImageLoader.simpleLoad(placeDetail.result.icon, imageView: iconImageView)
            }
            refreshContentLabel()
        }else if placeDetail.result.placeID == lastPoint?.placeID{
            endName = placeDetail.result.name
            refreshContentLabel()
        }
    }
    
}
