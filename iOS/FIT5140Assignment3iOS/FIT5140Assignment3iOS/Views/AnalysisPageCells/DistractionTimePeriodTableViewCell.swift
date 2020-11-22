//
//  DistractionTimePeriodTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/21.
//

import UIKit
import Charts
class DistractionTimePeriodTableViewCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentAreaBackground: UIView!
    @IBOutlet weak var pieChart: PieChartView!
    static let identifier = "DistractionTimePeriodTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "DistractionTimePeriodTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentAreaBackground.layer.cornerRadius = 24
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
