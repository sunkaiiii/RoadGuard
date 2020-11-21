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
    let DISTRACTION_PERIOD_CELL_ID = "DistractionTimePeriodTableViewCell"

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
        analysisPageTableView.register(DistractionTimePeriodTableViewCell.nib(), forCellReuseIdentifier: DISTRACTION_PERIOD_CELL_ID)

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
            //segment 0 : upper section is a bar chart - daily distance
            if indexPath.section == SECTION_UPPER {
                let cell = tableView.dequeueReusableCell(withIdentifier: DRIVING_DISTANC_CELL_ID, for: indexPath) as! DrienDistanceTableViewCell

                var barChartDataEntries = [BarChartDataEntry]()

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
            }
            //segment 0 : bottom section is a pie chart, general driving status percentage
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DRIVINGSTATUS_CELL_ID, for: indexPath) as! DrivingStatusTableViewCell
                cell.pieChart.delegate = self

                let allGoodDataEntry = PieChartDataEntry(value: 0)
                let likelyFocusDataEntry = PieChartDataEntry(value: 0)
                let distractionDataEntry = PieChartDataEntry(value: 0)
                let overSpeedDataEntry = PieChartDataEntry(value: 0)

                var calmFacials : [FacialInfo] = []
                var happyFacials : [FacialInfo] = []
                var distractionFacials : [FacialInfo] = []
                var overSpeedRecords : [FacialInfo] = []

                var pieChartDataEnties = [PieChartDataEntry]()

                for element in facialInfoList {
                    let facialDetails = element.faceDetails

                    if element.speed > 0, element.speedLimit != nil, element.speedLimit! > 0, element
                        .speed > element.speedLimit!{
                        overSpeedRecords.append(element)
                    } else if facialDetails.count > 0 {
                        let emotions = facialDetails[0].emotions
                        if emotions[0].type == "CALM"{
                            calmFacials.append(element)
                        } else if emotions[0].type == "HAPPY"{
                            happyFacials.append(element)
                        } else {
                            distractionFacials.append(element)
                        }
                    }

                }

                cell.pieChart.chartDescription?.text = ""

                func rounndPercent(top:Int, bottom:Int)->Double{
                    return (Double(top)/Double(bottom)*100).rounded(.up)
                }

                var percent = rounndPercent(top: calmFacials.count, bottom: facialInfoList.count)
                cell.allgoodPercentLabel.text = "\(percent)%"
                allGoodDataEntry.value = Double(percent)
                allGoodDataEntry.label = "All Good"

                percent = rounndPercent(top: happyFacials.count, bottom: facialInfoList.count)
                cell.likelyFocusPercentLabel.text = "\(percent)%"
                likelyFocusDataEntry.value = Double(percent)
                likelyFocusDataEntry.label = "Likely Focused"

                percent = rounndPercent(top: distractionFacials.count, bottom: facialInfoList.count)
                cell.distractionPercentLabel.text = "\(percent)%"
                distractionDataEntry.value = Double(percent)
                distractionDataEntry.label = "Distraction"

                percent = rounndPercent(top: overSpeedRecords.count, bottom: facialInfoList.count)
                cell.overspeedPercentLabel.text = "\(percent)%"
                overSpeedDataEntry.value = Double(percent)
                overSpeedDataEntry.label = "OverSpeed"

                var colors : [NSUIColor] = []

                if allGoodDataEntry.value > 0{
                    pieChartDataEnties.append(allGoodDataEntry)
                    let allGoodColor = NSUIColor(named: "analysis-allgood")
                    colors.append(allGoodColor!)
                }

                if likelyFocusDataEntry.value > 0{
                    pieChartDataEnties.append(likelyFocusDataEntry)
                    let likelyFocusColor = NSUIColor(named: "analysis-likelyFocus")
                    colors.append(likelyFocusColor!)
                }

                if distractionDataEntry.value > 0{
                    pieChartDataEnties.append(distractionDataEntry)
                    let distractionColor = NSUIColor(named: "analysis-distraction")
                    colors.append(distractionColor!)
                }

                if overSpeedDataEntry.value > 0{
                    pieChartDataEnties.append(overSpeedDataEntry)
                    let overSpeedColor = NSUIColor(named: "analysis-overspeed")
                    colors.append(overSpeedColor!)
                }

                let chartDataSet = PieChartDataSet(entries: pieChartDataEnties, label: nil)

                chartDataSet.colors = colors
                chartDataSet.valueLinePart1OffsetPercentage = 0.8
                chartDataSet.valueLinePart1Length = 0.2
                chartDataSet.valueLinePart2Length = 0.4
                chartDataSet.xValuePosition = .outsideSlice
                chartDataSet.yValuePosition = .outsideSlice

                let chartData = PieChartData(dataSet: chartDataSet)

                let pFormatter = NumberFormatter()
                pFormatter.numberStyle = .percent
                pFormatter.maximumFractionDigits = 1
                pFormatter.multiplier = 1
                pFormatter.percentSymbol = " %"
                chartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
                chartData.setValueTextColor(.black)
                chartData.setValueFont(.systemFont(ofSize: 8, weight: .light))

                cell.pieChart.data = chartData
                cell.pieChart.entryLabelColor = .black
                cell.pieChart.entryLabelFont = .systemFont(ofSize: 10, weight: .light)
                cell.pieChart.legend.enabled = false

                return cell
            }
        }

        else if segmentControl.selectedSegmentIndex == 1{
            //segment 1 : upper section is a bar chart - daily distraction times
            if indexPath.section == SECTION_UPPER {
                let cell = tableView.dequeueReusableCell(withIdentifier: DRIVING_DISTANC_CELL_ID, for: indexPath) as! DrienDistanceTableViewCell
                cell.headerLaebl.text = "Distraction Times"
                let barChart = cell.barChart
                barChart!.delegate = self
                barChart!.chartDescription?.text = ""
                barChart?.legend.enabled = false
                var barChartDataEntries = [BarChartDataEntry]()

                let formatter = DateFormatter()
                formatter.timeZone = .current
                formatter.locale = .current
                formatter.dateFormat = "dd-MM-yyyy"

                var arrayOfDayAndCountTuple : [(String,Int)] = []
                for record in facialInfoList{
                    let facialDetails = record.faceDetails
                    if record.speed > 0, record.speedLimit != nil, record.speedLimit! > 0, record                        .speed > record.speedLimit!{
                    //do nothing when over speed
                    } else if facialDetails.count > 0 {
                        let emotions = facialDetails[0].emotions
                        if emotions[0].type == "CALM"{
                            //do nothing when all good

                        } else if emotions[0].type == "HAPPY"{
                            //do nothing when likely focusing
                        } else {
                            //face showing distraction
                            let dateOfOneRecord = formatter.string(from: record.capturedTime)

                            let indexOfMatchingRecord = arrayOfDayAndCountTuple.firstIndex(where: { (existingRecord:(String,Int)) ->Bool in return existingRecord.0 == dateOfOneRecord })

                            if indexOfMatchingRecord != nil
                            {
                                //if already existing record in the same day, then sum the distance
                                let originalCount = arrayOfDayAndCountTuple[indexOfMatchingRecord!].1
                                arrayOfDayAndCountTuple[indexOfMatchingRecord!].1 = originalCount + 1
                            } else {
                                //if the date not in the array yet, then add new tuple into the array
                                arrayOfDayAndCountTuple.append((dateOfOneRecord,1))
                            }
                        }
                    }
                }

                var labels : [String] = []

                var counter = 0
                for element in arrayOfDayAndCountTuple {
                    let dataEntry = BarChartDataEntry(x: Double(counter), y: Double(element.1))
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
            }
            //segment 1 : bottom section is pie chart - distraction time period
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DISTRACTION_PERIOD_CELL_ID, for: indexPath) as! DistractionTimePeriodTableViewCell

                var distractionFacials : [FacialInfo] = []
                distractionFacials = facialInfoList.filter({ (element) -> Bool in
                    let facialDetails = element.faceDetails
                    if element.speed > 0, element.speedLimit != nil, element.speedLimit! > 0, element
                        .speed > element.speedLimit!{
                        //return false when overspeed
                        return false
                    } else if facialDetails.count > 0 {
                        let emotions = facialDetails[0].emotions
                        if emotions[0].type == "CALM"{
                            //return false when all good
                            return false
                        } else if emotions[0].type == "HAPPY"{
                            //return false when all likely focus
                            return false
                        } else {
                            //return true when distraction
                            return true
                        }
                    } else {
                        //return false when record not valid
                        return false
                    }
                })

                let formatter = DateFormatter()
                formatter.timeZone = .current
                formatter.locale = .current
                formatter.dateFormat = "hh-a"

                var arrayOfTimeAndCountTuple : [(String,Int)] = []

                for record in distractionFacials{

                    let timeOfOneRecord = formatter.string(from: record.capturedTime)

                    let indexOfMatchingRecord = arrayOfTimeAndCountTuple.firstIndex(where: { (existingRecord:(String,Int)) ->Bool in return existingRecord.0 == timeOfOneRecord })

                    if indexOfMatchingRecord != nil
                    {
                        //if already existing record in the same day, then sum the distance
                        let originalCount = arrayOfTimeAndCountTuple[indexOfMatchingRecord!].1
                        arrayOfTimeAndCountTuple[indexOfMatchingRecord!].1 = originalCount + 1
                    } else {
                        //if the date not in the array yet, then add new tuple into the array
                        arrayOfTimeAndCountTuple.append((timeOfOneRecord,1))
                    }
                }

                cell.pieChart.delegate = self
                cell.pieChart.chartDescription?.text = ""

                func rounndPercent(top:Int, bottom:Int)->Double{
                    return (Double(top)/Double(bottom)*100).rounded(.up)
                }

                var pieChartDataEnties = [PieChartDataEntry]()
                for tuple in arrayOfTimeAndCountTuple {
                    let roundPercent = rounndPercent(top: tuple.1, bottom: distractionFacials.count)
                    let splitTIme = tuple.0.split(separator: "-")
                    let timePeriodStart = Int(splitTIme[0])!
                    let timePeriodEnd = timePeriodStart + 1
                    pieChartDataEnties.append(PieChartDataEntry(value: roundPercent, label: "\(timePeriodStart)-\(timePeriodEnd) \(splitTIme[1])"))
                }

                let chartDataSet = PieChartDataSet(entries: pieChartDataEnties, label: nil)

                chartDataSet.colors = ChartColorTemplates.material()
                chartDataSet.valueLinePart1OffsetPercentage = 0.8
                chartDataSet.valueLinePart1Length = 0.2
                chartDataSet.valueLinePart2Length = 0.4
                chartDataSet.xValuePosition = .outsideSlice
                chartDataSet.yValuePosition = .outsideSlice

                let chartData = PieChartData(dataSet: chartDataSet)

                let pFormatter = NumberFormatter()
                pFormatter.numberStyle = .percent
                pFormatter.maximumFractionDigits = 0
                pFormatter.multiplier = 1
                pFormatter.percentSymbol = " %"
                chartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
                chartData.setValueTextColor(.black)
                chartData.setValueFont(.systemFont(ofSize: 8, weight: .light))

                cell.pieChart.data = chartData
                cell.pieChart.entryLabelColor = .black
                cell.pieChart.entryLabelFont = .systemFont(ofSize: 10, weight: .light)
                cell.pieChart.legend.enabled = false

                return cell
            }
        }
        else {
            //segment 2 : upper section is a bar chart - daily overspeed times
            if indexPath.section == SECTION_UPPER {
                let cell = tableView.dequeueReusableCell(withIdentifier: DRIVING_DISTANC_CELL_ID, for: indexPath) as! DrienDistanceTableViewCell
                cell.headerLaebl.text = "OverSpeed Times"
                let barChart = cell.barChart
                barChart!.delegate = self
                barChart!.chartDescription?.text = ""
                barChart?.legend.enabled = false


                let formatter = DateFormatter()
                formatter.timeZone = .current
                formatter.locale = .current
                formatter.dateFormat = "dd-MM-yyyy"

                var arrayOfDayAndCountTuple : [(String,Int)] = []
                for record in facialInfoList{

                    if record.speed > 0, record.speedLimit != nil, record.speedLimit! > 0, record                        .speed > record.speedLimit!{
                        let dateOfOneRecord = formatter.string(from: record.capturedTime)

                        let indexOfMatchingRecord = arrayOfDayAndCountTuple.firstIndex(where: { (existingRecord:(String,Int)) ->Bool in return existingRecord.0 == dateOfOneRecord })

                        if indexOfMatchingRecord != nil
                        {
                            //if already existing record in the same day, then sum the distance
                            let originalCount = arrayOfDayAndCountTuple[indexOfMatchingRecord!].1
                            arrayOfDayAndCountTuple[indexOfMatchingRecord!].1 = originalCount + 1
                        } else {
                            //if the date not in the array yet, then add new tuple into the array
                            arrayOfDayAndCountTuple.append((dateOfOneRecord,1))
                        }
                    }
                }

                var barChartDataEntries = [BarChartDataEntry]()
                var labels : [String] = []

                var counter = 0
                for element in arrayOfDayAndCountTuple {
                    let dataEntry = BarChartDataEntry(x: Double(counter), y: Double(element.1))
                    let dateComponents = element.0.split(separator: "-")
                    let label = "\(dateComponents[0])/\(dateComponents[1])"
                    labels.append(label)
                    barChartDataEntries.append(dataEntry)
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
            }
            
            //Todo
            //segment 2 : bottom section is a xx chart - xx
            else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DRIVINGSTATUS_CELL_ID, for: indexPath) as! DrivingStatusTableViewCell
                return cell
            }
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

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath,animated:true)
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
        facialInfoList = facialInfos
        analysisPageTableView.reloadData()
    }

    func onDrivingRecordChange(change:DatabaseChange, drivingRecord:[DrivingRecordResponse]){
        self.drivingRecordList = drivingRecord
        analysisPageTableView.reloadData()
    }
}
