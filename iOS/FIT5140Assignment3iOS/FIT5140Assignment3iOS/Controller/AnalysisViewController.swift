//
//  AnalysisViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/2.
//

import UIKit
import Charts

class AnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var analysisPageTableView: UITableView!
    
    let SECTION_UPPER = 0
    let SECTION_LOWER = 1
    let DRIVINGSTATUS_CELL_ID = "DrivingStatusTableViewCell"

    var allGoodDataEntry = PieChartDataEntry(value: 0)
    var likelyFocusDataEntry = PieChartDataEntry(value: 0)
    var distractionDataEntry = PieChartDataEntry(value: 0)
    var overSpeedDataEntry = PieChartDataEntry(value: 0)
    var dataEnties = [PieChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        analysisPageTableView.delegate = self
        analysisPageTableView.dataSource = self
        analysisPageTableView.register(DrivingStatusTableViewCell.nib(), forCellReuseIdentifier: DRIVINGSTATUS_CELL_ID)
//        analysisPageTableView.rowHeight = UITableView.automaticDimension
//        analysisPageTableView.estimatedRowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_UPPER {
            let cell = tableView.dequeueReusableCell(withIdentifier: DRIVINGSTATUS_CELL_ID, for: indexPath) as! DrivingStatusTableViewCell
            cell.pieChart.chartDescription?.text = "test"
            allGoodDataEntry.value = 89
            likelyFocusDataEntry.value = 4
            distractionDataEntry.value = 1
            overSpeedDataEntry.value = 6
            dataEnties = [allGoodDataEntry,likelyFocusDataEntry,distractionDataEntry,overSpeedDataEntry]
            updateChartData(pieChart: cell.pieChart)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DRIVINGSTATUS_CELL_ID, for: indexPath) as! DrivingStatusTableViewCell
            cell.pieChart.chartDescription?.text = "test"
            allGoodDataEntry.value = 89
            likelyFocusDataEntry.value = 4
            distractionDataEntry.value = 1
            overSpeedDataEntry.value = 6
            dataEnties = [allGoodDataEntry,likelyFocusDataEntry,distractionDataEntry,overSpeedDataEntry]
            updateChartData(pieChart: cell.pieChart)
            return cell
        }
    }

    //考虑是否在这里调高度
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//      return
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func updateChartData(pieChart : PieChartView) {

        let chartDataSet = PieChartDataSet(entries: dataEnties, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)

       
        let colors = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.black]
        chartDataSet.colors = colors
        pieChart.data = chartData
    }

}
