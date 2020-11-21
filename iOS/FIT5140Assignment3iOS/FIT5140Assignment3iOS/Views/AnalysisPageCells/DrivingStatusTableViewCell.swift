//
//  DrivingStatusTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/2.
//

import UIKit
import Charts

class DrivingStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var contentAreaBackground: UIView!
    @IBOutlet weak var allGoodBackGroun: UIView!

    @IBOutlet weak var likelyFocusBackground: UIView!
    
    @IBOutlet weak var distractionBackground: UIView!
    
    @IBOutlet weak var overSpeedBackground: UIView!
    
    @IBOutlet weak var pieChart: PieChartView!

    @IBOutlet weak var allgoodPercentLabel: UILabel!

    @IBOutlet weak var likelyFocusPercentLabel: UILabel!
    @IBOutlet weak var distractionPercentLabel: UILabel!
    @IBOutlet weak var overspeedPercentLabel: UILabel!
    
    static let identifier = "DrivingStatusTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "DrivingStatusTableViewCell", bundle: nil)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        allGoodBackGroun.layer.cornerRadius = 24
        likelyFocusBackground.layer.cornerRadius = 24
        distractionBackground.layer.cornerRadius = 24
        overSpeedBackground.layer.cornerRadius = 24
        contentAreaBackground.layer.cornerRadius = 24
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
