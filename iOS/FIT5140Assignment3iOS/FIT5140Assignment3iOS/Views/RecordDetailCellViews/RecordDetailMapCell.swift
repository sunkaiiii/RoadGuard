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
    
}
