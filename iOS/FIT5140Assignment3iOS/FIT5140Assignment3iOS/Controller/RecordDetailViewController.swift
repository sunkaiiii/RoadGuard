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
    //test data
    let lineChartDataEntries : [ChartDataEntry] = [
        ChartDataEntry(x:0.0, y:3.0),
        ChartDataEntry(x:1.0, y:1.0),
        ChartDataEntry(x:2.0, y:4.0),
        ChartDataEntry(x:3.0, y:1.0),
        ChartDataEntry(x:4.0, y:5.0),
        ChartDataEntry(x:5.0, y:9.0),
        ChartDataEntry(x:6.0, y:2.0),
        ChartDataEntry(x:7.0, y:6.0),
        ChartDataEntry(x:8.0, y:5.0),
        ChartDataEntry(x:9.0, y:4.0),
        ChartDataEntry(x:10.0, y:5.0),
        ChartDataEntry(x:11.0, y:7.0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        recordDetailTableView.delegate = self
        recordDetailTableView.dataSource = self
        recordDetailTableView.register(RecordDetailMapCell.nib(), forCellReuseIdentifier: MAP_CELL_ID)
        recordDetailTableView.register(RecordDetailMatrixCell.nib(), forCellReuseIdentifier: MATRIX_CELL_ID)
        recordDetailTableView.register(RecordDetailChartCell.nib(), forCellReuseIdentifier: CHART_CELL_ID)
//        recordDetailTableView.register(BottomCardImportantRoadCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)
//        recordDetailTableView.register(BottomCardImportantRoadCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)
//        recordDetailTableView.register(BottomCardImportantRoadCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)
        recordDetailTableView.register(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL_ID)
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
            let lineChart = cell.lineChartOutlet
            let horizontalBarChart = cell.horizontalBarChartOutlet

            return cell
        } else {
            //SECTION_DISTRACTION_SUMMARY
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "Important Roads"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_MAP {
            return self.view.frame.width - 20

        } else if indexPath.section == SECTION_MATRIX{
            return self.view.frame.height / 4 + 20
        } else if indexPath.section == SECTION_CHART{
            return 50
        } else {
            //SECTION_DISTRACTION
            return 50
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_DISTRACTION_SUMMARY{
            //跳转
        } else{
            recordDetailTableView.deselectRow(at:indexPath,animated:true)
        }
    }
}
