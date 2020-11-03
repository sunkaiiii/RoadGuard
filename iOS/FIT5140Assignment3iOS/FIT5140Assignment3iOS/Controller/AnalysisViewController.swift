//
//  AnalysisViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/2.
//

import UIKit
import Charts

class AnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ChartViewDelegate {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var analysisPageTableView: UITableView!
    
    let SECTION_UPPER = 0
    let SECTION_LOWER = 1
    let DRIVINGSTATUS_CELL_ID = "DrivingStatusTableViewCell"
    let DRIVING_DISTANC_CELL_ID = "DrienDistanceTableViewCell"

    var allGoodDataEntry = PieChartDataEntry(value: 0)
    var likelyFocusDataEntry = PieChartDataEntry(value: 0)
    var distractionDataEntry = PieChartDataEntry(value: 0)
    var overSpeedDataEntry = PieChartDataEntry(value: 0)
    var pieChartDataEnties = [PieChartDataEntry]()
    var barChartDataEntries = [BarChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        analysisPageTableView.delegate = self
        analysisPageTableView.dataSource = self
        analysisPageTableView.register(DrivingStatusTableViewCell.nib(), forCellReuseIdentifier: DRIVINGSTATUS_CELL_ID)
        analysisPageTableView.register(DrienDistanceTableViewCell.nib(), forCellReuseIdentifier: DRIVING_DISTANC_CELL_ID)
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
        if segmentControl.selectedSegmentIndex == 0{
            if indexPath.section == SECTION_UPPER {
                let cell = tableView.dequeueReusableCell(withIdentifier: DRIVINGSTATUS_CELL_ID, for: indexPath) as! DrivingStatusTableViewCell
                cell.pieChart.delegate = self
                cell.pieChart.chartDescription?.text = ""
                allGoodDataEntry.value = 89
                likelyFocusDataEntry.value = 4
                distractionDataEntry.value = 1
                overSpeedDataEntry.value = 6
                pieChartDataEnties = [allGoodDataEntry,likelyFocusDataEntry,distractionDataEntry,overSpeedDataEntry]
                updatePieChartData(pieChart: cell.pieChart)
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DRIVING_DISTANC_CELL_ID, for: indexPath) as! DrienDistanceTableViewCell
                let barChart = cell.barChart
                barChart!.delegate = self
                barChart!.chartDescription?.text = ""

                //这里写个循环调用数据放进BarChartDataEntry
                for i in 1...5{
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(i*100))
                    barChartDataEntries.append(dataEntry)
                }
                let set = BarChartDataSet(barChartDataEntries)
                set.colors = ChartColorTemplates.colorful()
                let data = BarChartData(dataSet: set)
                barChart!.data = data
                barChart!.rightAxis.enabled = false

                let yAxis = barChart!.leftAxis
                yAxis.labelFont = .boldSystemFont(ofSize: 12)
                yAxis.labelPosition = .outsideChart

                let xAxis = barChart?.xAxis
                xAxis?.labelPosition = .bottom
                xAxis?.labelFont = .boldSystemFont(ofSize: 12)
                xAxis?.setLabelCount(10, force: false)
                barChart?.animate(xAxisDuration: 2.5)
                barChartDataEntries.removeAll()
                return cell
            }

        }
        let cell = tableView.dequeueReusableCell(withIdentifier: DRIVINGSTATUS_CELL_ID, for: indexPath) as! DrivingStatusTableViewCell
        cell.pieChart.delegate = self
        cell.pieChart.chartDescription?.text = ""
        allGoodDataEntry.value = 89
        likelyFocusDataEntry.value = 4
        distractionDataEntry.value = 1
        overSpeedDataEntry.value = 6
        pieChartDataEnties = [allGoodDataEntry,likelyFocusDataEntry,distractionDataEntry,overSpeedDataEntry]
        updatePieChartData(pieChart: cell.pieChart)
        return cell

    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_UPPER{
            return self.view.frame.width
        } else {
            return self.view.frame.width
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func updatePieChartData(pieChart : PieChartView) {

        let chartDataSet = PieChartDataSet(entries: pieChartDataEnties, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)


        let colors = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.black]
        chartDataSet.colors = colors
        pieChart.data = chartData
    }


    @IBAction func segmentControlClicked(_ sender: Any) {
        analysisPageTableView.reloadData()
    }

}
