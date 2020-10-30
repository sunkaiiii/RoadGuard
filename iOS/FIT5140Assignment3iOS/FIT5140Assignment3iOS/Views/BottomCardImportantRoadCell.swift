//
//  BottomCardImportantRoadCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/25.
//

import UIKit

class BottomCardImportantRoadCell: UITableViewCell {
    @IBOutlet var iconImageView : UIImageView!
    @IBOutlet var headerLabel : UILabel!
    @IBOutlet var contentLabel : UILabel!
    @IBOutlet var distanceLabel : UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!


    static let identifier = "BottomCardImportantRoadCell"
    static func nib()->UINib{
        return UINib(nibName: "BottomCardImportantRoadCell", bundle: nil)
    }

    public func configure(iconImageViewName: String,headerLabel: String, contentLabel: String, distanceLabel: String, timeLabel: String){
        self.iconImageView.image = UIImage(systemName: iconImageViewName)
        self.headerLabel.text = headerLabel
        self.contentLabel.text = contentLabel
        self.distanceLabel.text = distanceLabel
        self.timeLabel.text = timeLabel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.contentMode = .scaleAspectFit
        backgroundColorView.layer.cornerRadius = 24
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
