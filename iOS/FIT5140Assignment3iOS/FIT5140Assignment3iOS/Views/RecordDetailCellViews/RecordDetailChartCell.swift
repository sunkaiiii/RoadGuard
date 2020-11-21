//
//  RecordDetailChartCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit
import Charts
class RecordDetailChartCell: UITableViewCell, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource,DefaultHttpRequestAction {


    @IBOutlet weak var backgroundVisualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var lineChartOutlet: LineChartView!

    @IBOutlet weak var barChartTableVIew: UITableView!
    
    let CELL_ID = BarChartTableViewCell.identifier
    var barChartTableViewDataSource:[(String,Int)] = []
    var speedList:[SpeedRecord] = []

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
    
    func initLineChart(_ drivingRecord:DrivingRecordResponse?){
        guard let drivingRecord = drivingRecord else{
            return
        }
        //configure line chart data
        let dataSet = LineChartDataSet(entries: getLineChartEntries(drivingRecord), label: "km/h")
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

        self.lineChartOutlet?.data = lineChartData

    }
    
    private func getLineChartEntries(_ drivingRecord:DrivingRecordResponse)->[ChartDataEntry]{
        var lineChartDataEntries : [ChartDataEntry] = []
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate, let databaseController = appdelegate.firebaseController, let id = drivingRecord.id{
            let speedList = databaseController.getSpeedRecordByRecordId(id)
            var index = 0.0
            speedList.forEach({(speed) in
                lineChartDataEntries.append(ChartDataEntry(x: index, y: Double(speed.currentSpeed)))
                index += 1
            })
        }
        
        return lineChartDataEntries
    }
    
    func initBarChart(_ drivingRecord:DrivingRecordResponse?){
        guard let drivingRecord = drivingRecord else{
            return
        }
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate, let databaseController = appdelegate.firebaseController, let id = drivingRecord.id{
            var lats:[Double] = []
            var longs:[Double] = []
            let speedList = databaseController.getSpeedRecordByRecordId(id)
            self.speedList = speedList
            speedList.forEach({(speed) in
                lats.append(speed.latitude)
                longs.append(speed.longitude)
            })
            requestCachegableDataFromRestfulService(api: GoogleApi.nearestRoads, model: NearestRoadsRequest(lat: lats, log: longs), jsonType: NearestRoadResponse.self, cachegableHelper: NearestRoadResponseCacheHelper())
        }
    }

    func handleResponseDataFromRestfulRequest(helper: RequestHelper, url: URLComponents, accessibleData: AccessibleNetworkData) {
        switch helper.restfulAPI as? GoogleApi {
        case .nearestRoads:
            let roads:NearestRoadResponse = accessibleData.retriveData()
            if roads.snappedPoints.count == 0{
                return
            }
            var currentIndex = roads.snappedPoints[0].originalIndex
            barChartTableViewDataSource.append((roads.snappedPoints[0].placeID,Int(speedList[currentIndex].currentSpeed)))
            roads.snappedPoints.forEach({(point) in
                if currentIndex != point.originalIndex{
                    currentIndex = point.originalIndex
                    barChartTableViewDataSource.append((point.placeID,Int(speedList[currentIndex].currentSpeed)))
                }
                
            })
            barChartTableVIew.reloadData()
        default:
            return
        }
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
        let data = barChartTableViewDataSource[indexPath.row]
        cell.initBarChartCell(data)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.barChartTableVIew.frame.height / 4
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {       
        tableView.deselectRow(at:indexPath,animated:true)
    }
}

