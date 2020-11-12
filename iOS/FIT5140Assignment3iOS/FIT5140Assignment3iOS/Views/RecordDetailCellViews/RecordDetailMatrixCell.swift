//
//  RecordDetailMatrixCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit

class RecordDetailMatrixCell: UITableViewCell {
    @IBOutlet weak var backgroundVisualEffectView: UIVisualEffectView!

    @IBOutlet weak var totalLengthLabel: UILabel!
    @IBOutlet weak var distractionTimesLabel: UILabel!
    
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var drivingDurationLabel: UILabel!
    static let identifier = "RecordDetailMatrixCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailMatrixCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let blurEffect = UIBlurEffect(style: .light)
//        backgroundVisualEffectView.effect = blurEffect
        backgroundVisualEffectView.layer.cornerRadius = 24
        backgroundVisualEffectView.contentView.layer.cornerRadius = 24
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
