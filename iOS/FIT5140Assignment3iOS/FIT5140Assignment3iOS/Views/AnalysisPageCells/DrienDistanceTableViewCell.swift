//
//  DrienDistanceTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/2.
//

import UIKit
import Charts

class DrienDistanceTableViewCell: UITableViewCell {
    @IBOutlet weak var contentBackgroundview: UIView!
    @IBOutlet weak var barChart: BarChartView!

    static let identifier = "DrienDistanceTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "DrienDistanceTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        contentBackgroundview.layer.cornerRadius = 24
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
