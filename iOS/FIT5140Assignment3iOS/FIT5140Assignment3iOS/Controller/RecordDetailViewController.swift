//
//  RecordDetailViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit
import Charts

class RecordDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recordDetailTableView: UITableView!

    //需要更改数据类型
    var selectedRecord : String?
    
    let SECTION_MAP = 0
    let SECTION_MATRIX = 1
    let SECTION_CHART = 2
    let SECTION_DISTRACTION_SUMMARY = 3
    let DEFAULT_CELL_ID = "DefaultCell"
    let MAP_CELL_ID = RecordDetailMapCell.identifier
    let MATRIX_CELL_ID = RecordDetailMatrixCell.identifier
    let CHART_CELL_ID = RecordDetailChartCell.identifier
    let DISTRACTION_CELL_ID = RecordDetailDistractionSummaryCell.identifier
    //test data
    let lineChartDataEntries : [ChartDataEntry] = [
        ChartDataEntry(x:0.0, y:3.0),
        ChartDataEntry(x:1.0, y:8.0),
        ChartDataEntry(x:2.0, y:15.0),
        ChartDataEntry(x:3.0, y:25.0),
        ChartDataEntry(x:4.0, y:35.0),
        ChartDataEntry(x:5.0, y:50.0),
        ChartDataEntry(x:6.0, y:65.0),
        ChartDataEntry(x:7.0, y:75.0),
        ChartDataEntry(x:8.0, y:80.0),
        ChartDataEntry(x:9.0, y:65.0),
        ChartDataEntry(x:10.0, y:55.0),
        ChartDataEntry(x:11.0, y:35.0)
    ]

    let barChartDataEntries : [BarChartDataEntry] = [

        BarChartDataEntry(x:0.0, y:3.0),
        BarChartDataEntry(x:1.0, y:8.0),
        BarChartDataEntry(x:2.0, y:15.0),
        BarChartDataEntry(x:3.0, y:25.0),
        BarChartDataEntry(x:4.0, y:35.0),
        BarChartDataEntry(x:5.0, y:50.0),
        BarChartDataEntry(x:6.0, y:65.0),
        BarChartDataEntry(x:7.0, y:75.0),
        BarChartDataEntry(x:8.0, y:80.0),
        BarChartDataEntry(x:9.0, y:65.0),
        BarChartDataEntry(x:10.0, y:55.0),
        BarChartDataEntry(x:11.0, y:35.0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        recordDetailTableView.delegate = self
        recordDetailTableView.dataSource = self
        recordDetailTableView.register(RecordDetailMapCell.nib(), forCellReuseIdentifier: MAP_CELL_ID)
        recordDetailTableView.register(RecordDetailMatrixCell.nib(), forCellReuseIdentifier: MATRIX_CELL_ID)
        recordDetailTableView.register(RecordDetailChartCell.nib(), forCellReuseIdentifier: CHART_CELL_ID)
        recordDetailTableView.register(RecordDetailDistractionSummaryCell.nib(), forCellReuseIdentifier: DISTRACTION_CELL_ID)
        // Do any additional setup after loading the view.
    }
    

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_MAP {
            let cell = tableView.dequeueReusableCell(withIdentifier: MAP_CELL_ID, for: indexPath) as! RecordDetailMapCell
      
            return cell
        } else if indexPath.section == SECTION_MATRIX{
            let cell = tableView.dequeueReusableCell(withIdentifier: MATRIX_CELL_ID, for: indexPath) as! RecordDetailMatrixCell

            return cell
        } else if indexPath.section == SECTION_CHART{
            let cell = tableView.dequeueReusableCell(withIdentifier: CHART_CELL_ID, for: indexPath) as! RecordDetailChartCell
            //configure chart data here

            //configure line chart data
            let dataSet = LineChartDataSet(entries: lineChartDataEntries, label: "km/h")
            //disable the big circle in the chart
            dataSet.drawCirclesEnabled = false
            //make the line looks more smooth
            dataSet.mode = .cubicBezier
            //line width
//            dataSet.lineWidth = 1
            //white line
            dataSet.setColor(.white)
            let lineChartData = LineChartData(dataSet: dataSet)
            //hide the number on each point of the line
            lineChartData.setDrawValues(false)

            let lineChart = cell.lineChartOutlet
            lineChart?.data = lineChartData

            //configure horizontal bar chart data
            //有待再调整，现在做的和设计图差异较大
            let horizontolBarChartDataSet = BarChartDataSet(entries: barChartDataEntries)
            horizontolBarChartDataSet.setColor(UIColor(red: 0.45, green: 0.74, blue: 0.94, alpha: 1.00))
            let horizontalBarChartData = BarChartData(dataSet: horizontolBarChartDataSet)
            let horizontalBarChart = cell.horizontalBarChartOutlet
            horizontalBarChart?.data = horizontalBarChartData

            return cell



        } else {
            //SECTION_DISTRACTION_SUMMARY
            let cell = tableView.dequeueReusableCell(withIdentifier: DISTRACTION_CELL_ID, for: indexPath) as! RecordDetailDistractionSummaryCell

            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_MAP {
            return self.view.frame.width - 20

        } else if indexPath.section == SECTION_MATRIX{
            return self.view.frame.height / 4 + 20
        } else if indexPath.section == SECTION_CHART{
            return self.view.frame.height / 2 + 30
        } else {
            //SECTION_DISTRACTION
            return self.view.frame.height / 4 + 120
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_DISTRACTION_SUMMARY{
            //跳转
            //考虑从这里点击跳转 还是子tableView点击跳转
            recordDetailTableView.deselectRow(at:indexPath,animated:true)
        } else{
            recordDetailTableView.deselectRow(at:indexPath,animated:true)
        }
    }
}