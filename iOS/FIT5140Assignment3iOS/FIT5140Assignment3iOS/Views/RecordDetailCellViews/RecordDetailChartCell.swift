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

        lineChartOutlet.noDataText = "No Data Avaiable"
        lineChartOutlet.backgroundColor = .clear
        lineChartOutlet.drawGridBackgroundEnabled = false

        lineChartOutlet.rightAxis.enabled = false
        lineChartOutlet.leftAxis.axisLineColor = .white
        lineChartOutlet.leftAxis.drawLabelsEnabled = false
        lineChartOutlet.leftAxis.drawGridLinesEnabled = false


        lineChartOutlet.xAxis.labelPosition = .bottom
        lineChartOutlet.xAxis.axisLineColor = .white
        lineChartOutlet.xAxis.drawLabelsEnabled = false
        lineChartOutlet.xAxis.drawGridLinesEnabled = false

        lineChartOutlet.legend.enabled = false
    
        horizontalBarChartOutlet.noDataText = "No Data Avaiable"
        horizontalBarChartOutlet.backgroundColor = .clear
        horizontalBarChartOutlet.drawGridBackgroundEnabled = false
        horizontalBarChartOutlet.rightAxis.enabled = false
        horizontalBarChartOutlet.leftAxis.enabled = false
        horizontalBarChartOutlet.xAxis.enabled = false
        horizontalBarChartOutlet.legend.enabled = false

        horizontalBarChartOutlet.drawValueAboveBarEnabled = true
        horizontalBarChartOutlet.fitBars = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

