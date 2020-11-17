//
//  RecordDetailChartCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit
import Charts
class RecordDetailChartCell: UITableViewCell, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var backgroundVisualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var lineChartOutlet: LineChartView!

    @IBOutlet weak var barChartTableVIew: UITableView!
    
    let CELL_ID = BarChartTableViewCell.identifier
    //需要改为传入的值
    var barChartTableViewDataSource = [("street1", 60),("street2", 80),("street3", 90),("street4", 60),("street5", 120),("street6", 180),("street7", 260),("street1", 360),("street1", 120),("street1", 40),("street1", 20)]

    static let identifier = "RecordDetailChartCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailChartCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundVisualEffectView.layer.cornerRadius = 24
        backgroundVisualEffectView.contentView.layer.cornerRadius = 24
        barChartTableVIew.delegate = self
        barChartTableVIew.dataSource = self
        barChartTableVIew.register(BarChartTableViewCell.nib(), forCellReuseIdentifier: CELL_ID)


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
    

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barChartTableViewDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! BarChartTableViewCell
        //给cell传值
        cell.backgroundVisualEffect.layer.cornerRadius = 24
        cell.backgroundVisualEffect.contentView.layer.cornerRadius = 24

        let maxPossibleSpeed = CGFloat(360)
        let speed = CGFloat(barChartTableViewDataSource[indexPath.row].1)
        let name = barChartTableViewDataSource[indexPath.row].0
        let widthRatio = speed/maxPossibleSpeed

        let baseWidth = CGFloat(130)
        let totalGapWidth = CGFloat(110)

        if speed == CGFloat(0) {
            cell.barWidthConstraint.constant = baseWidth
        } else {
            cell.barWidthConstraint.constant = baseWidth + (self.frame.width - baseWidth - totalGapWidth) * widthRatio
        }


        cell.streetNameLabel.text = name
        //we don't use CGFloat result here
        cell.speedLabel.text =  "\(barChartTableViewDataSource[indexPath.row].1)km/h"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.barChartTableVIew.frame.height / 5
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {       
        tableView.deselectRow(at:indexPath,animated:true)
    }
}

