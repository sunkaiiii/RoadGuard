//
//  RecordDetailChartCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit
import Charts
class RecordDetailChartCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var backgroundVisualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var lineChartOutlet: LineChartView!

    @IBOutlet weak var horizontalBarChartOutlet: HorizontalBarChartView!

    static let identifier = "RecordDetailChartCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailChartCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundVisualEffectView.layer.cornerRadius = 24
        backgroundVisualEffectView.contentView.layer.cornerRadius = 24
        lineChartOutlet.backgroundColor = .clear
        horizontalBarChartOutlet.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
