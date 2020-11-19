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

    var listenerType: [ListenerType] = [.facial,.drivingRecord]


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


    var facialInfoList:[FacialInfo] = []
    var drivingRecordList:[DrivingRecordResponse] = []
    
    weak var firebaseController: DatabaseProtocol?

    // MARK: - view lifecycle
    override func viewDidLoad() {

        super.viewDidLoad()
        firebaseController = (UIApplication.shared.delegate as! AppDelegate).firebaseController
        analysisPageTableView.delegate = self
        analysisPageTableView.dataSource = self
        analysisPageTableView.register(DrivingStatusTableViewCell.nib(), forCellReuseIdentifier: DRIVINGSTATUS_CELL_ID)
        analysisPageTableView.register(DrienDistanceTableViewCell.nib(), forCellReuseIdentifier: DRIVING_DISTANC_CELL_ID)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseController?.removeListener(listener: self)
    }

    // MARK: - table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentIndex == 0{
            if indexPath.section == SECTION_UPPER {
                let cell = tableView.dequeueReusableCell(withIdentifier: DRIVING_DISTANC_CELL_ID, for: indexPath) as! DrienDistanceTableViewCell
                let barChart = cell.barChart
                barChart!.delegate = self
                barChart!.chartDescription?.text = ""
                barChart?.legend.enabled = false

                let formatter = DateFormatter()
                formatter.timeZone = .current
                formatter.locale = .current
                formatter.dateFormat = "dd-MM-yyyy"

                var arrayOfDayAndDistanceTuple : [(String,Double)] = []
                for record in drivingRecordList{
                    let dateOfOneRecord = formatter.string(from: record.startTime)

                    let indexOfMatchingRecord = arrayOfDayAndDistanceTuple.firstIndex(where: { (existingRecord:(String,Double)) ->Bool in return existingRecord.0 == dateOfOneRecord })


                    if indexOfMatchingRecord != nil
                    {
                        //if already existing record in the same day, then sum the distance
                        let originalDistance = arrayOfDayAndDistanceTuple[indexOfMatchingRecord!].1
                        arrayOfDayAndDistanceTuple[indexOfMatchingRecord!].1 = originalDistance + record.drivingDistance
                    } else {
                        //if the date not in the array yet, then add new tuple into the array
                        arrayOfDayAndDistanceTuple.append((dateOfOneRecord,record.drivingDistance))
                    }
                }
        

                var labels : [String] = []

                var counter = 0
                for element in arrayOfDayAndDistanceTuple {

                    let dataEntry = BarChartDataEntry(x: Double(counter), y: element.1)
                    let dateComponents = element.0.split(separator: "-")
                    let label = "\(dateComponents[0])/\(dateComponents[1])"
                    labels.append(label)
                    barChartDataEntries.append(dataEntry)
                    //Todo: 这里需要Charts的ValueFormatter用以替换x轴坐标label
                    counter += 1
                }

                let valueFormatterForXAxis = IndexAxisValueFormatter(values: labels)
                valueFormatterForXAxis.values = labels

                let set = BarChartDataSet(barChartDataEntries)
                set.colors = [NSUIColor.blue]
                let data = BarChartData(dataSet: set)
                barChart!.data = data
                barChart!.rightAxis.enabled = false

                let yAxis = barChart!.leftAxis
                yAxis.labelFont = .boldSystemFont(ofSize: 12)
                yAxis.labelPosition = .outsideChart

                let xAxis = barChart?.xAxis
                xAxis?.drawGridLinesEnabled = false
                xAxis?.labelPosition = .bottom
                xAxis?.labelFont = .boldSystemFont(ofSize: 12)

                xAxis?.valueFormatter = valueFormatterForXAxis
                xAxis?.labelCount = labels.count
                barChart?.animate(xAxisDuration: 1)
                barChartDataEntries.removeAll()
                return cell
            } else {
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

        }  else if segmentControl.selectedSegmentIndex == 1{
            //第二个segment,返回cell有待更新
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
            //第3个segment,返回cell有待更新
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

    // MARK: - Charts
    func updatePieChartData(pieChart : PieChartView) {

        let chartDataSet = PieChartDataSet(entries: pieChartDataEnties, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)


        let colors = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.black]
        chartDataSet.colors = colors
        pieChart.data = chartData
    }

    // MARK: - IBAction
    @IBAction func segmentControlClicked(_ sender: Any) {
        analysisPageTableView.reloadData()
    }
}

// MARK: - DB listener
extension AnalysisViewController: DatabaseListener{
    func onSelectedRoadInfoChange(change: DatabaseChange, selectRoads: [UserSelectedRoadResponse]) {
        
    }
    

    func onFacialInfoChange(change: DatabaseChange, facialInfos: [FacialInfo]) {
        //Todo 需要写一个简单算法，在tableView刷新时，根据facialInfoList，归类出chart所需数据
        facialInfoList = facialInfos
        analysisPageTableView.reloadData()
    }

    func onDrivingRecordChange(change:DatabaseChange, drivingRecord:[DrivingRecordResponse]){
        self.drivingRecordList = drivingRecord
        analysisPageTableView.reloadData()
    }
}
