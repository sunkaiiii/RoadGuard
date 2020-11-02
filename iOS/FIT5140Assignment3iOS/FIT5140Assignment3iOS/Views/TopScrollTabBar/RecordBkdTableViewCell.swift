//
//  RecordBkdTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/31.
//

import UIKit

class RecordBkdTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageOutlet: UIImageView!
    @IBOutlet weak var backgroundBorderAndColorViewOutlet: UIView!
    @IBOutlet weak var distanceLabelOutlet: UILabel!
    @IBOutlet weak var drivingTimeLabelOutlet: UILabel!    
    @IBOutlet weak var startAndEndPlaceLabelOutlet: UILabel!
    
    static let identifier = "RecordBkdTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordBkdTableViewCell", bundle: nil)
    }

    public func configure(iconImageViewName: String,distanceLabelOutlet: String, drivingTimeLabelOutlet: String, startAndEndPlaceLabelOutlet: String){
        self.iconImageOutlet.image = UIImage(systemName: iconImageViewName)
        self.distanceLabelOutlet.text = distanceLabelOutlet
        self.drivingTimeLabelOutlet.text = drivingTimeLabelOutlet
        self.startAndEndPlaceLabelOutlet.text = startAndEndPlaceLabelOutlet

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
    
}