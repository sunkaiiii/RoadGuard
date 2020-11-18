//
//  RecordDetailMapCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit
import GoogleMaps

class RecordDetailMapCell: UITableViewCell {

    @IBOutlet weak var googleMapView: GMSMapView!
    
    static let identifier = "RecordDetailMapCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailMapCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        googleMapView.layer.cornerRadius = 24
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initMapAndPath(_ drivingRecord:DrivingRecordResponse?){
        guard let drivingRecord = drivingRecord else {
            return
        }
        let gmsCamera = GMSCameraPosition.init(latitude:drivingRecord.startLocation.latitude , longitude: drivingRecord.startLocation.logitude, zoom: 14)
        self.googleMapView.camera = gmsCamera
        let path = GMSMutablePath()
        drivingRecord.path.forEach({(point) in
            path.add(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
        })
        let polyLine = GMSPolyline(path: path)
        polyLine.map = self.googleMapView
    }
    
}
