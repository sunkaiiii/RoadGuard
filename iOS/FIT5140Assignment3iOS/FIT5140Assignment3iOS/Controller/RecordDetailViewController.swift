//
//  RecordDetailViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit
import Charts

class RecordDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var recordDetailTableView: UITableView!
    var drivingRecord : DrivingRecordResponse?
    let SECTION_MAP = 0
    let SECTION_MATRIX = 1
    let SECTION_CHART = 2
    let SECTION_DISTRACTION_SUMMARY = 3
    let SECTION_OVER_SPEED_SUMMARY = 4
    let DEFAULT_CELL_ID = "DefaultCell"
    let MAP_CELL_ID = RecordDetailMapCell.identifier
    let MATRIX_CELL_ID = RecordDetailMatrixCell.identifier
    let CHART_CELL_ID = RecordDetailChartCell.identifier
    let DISTRACTION_CELL_ID = RecordDetailDistractionSummaryCell.identifier
    let OVER_SPEED_CELL_ID = RecordDeailOverSpeedTableViewCell.identifier
    let DISTRACTION_DETAIL_PAGE_SEGUE = "distractionDetailSegue"

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recordDetailTableView.delegate = self
        recordDetailTableView.dataSource = self
        recordDetailTableView.register(RecordDetailMapCell.nib(), forCellReuseIdentifier: MAP_CELL_ID)
        recordDetailTableView.register(RecordDetailMatrixCell.nib(), forCellReuseIdentifier: MATRIX_CELL_ID)
        recordDetailTableView.register(RecordDetailChartCell.nib(), forCellReuseIdentifier: CHART_CELL_ID)
        recordDetailTableView.register(RecordDetailDistractionSummaryCell.nib(), forCellReuseIdentifier: DISTRACTION_CELL_ID)
        recordDetailTableView.register(RecordDeailOverSpeedTableViewCell.nib(), forCellReuseIdentifier: OVER_SPEED_CELL_ID)
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_MAP {
            let cell = tableView.dequeueReusableCell(withIdentifier: MAP_CELL_ID, for: indexPath) as! RecordDetailMapCell
            cell.initMapAndPath(self.drivingRecord)
            return cell
        } else if indexPath.section == SECTION_MATRIX{
            let cell = tableView.dequeueReusableCell(withIdentifier: MATRIX_CELL_ID, for: indexPath) as! RecordDetailMatrixCell
            cell.initMatrixData(self.drivingRecord)
            return cell
        } else if indexPath.section == SECTION_CHART{
            let cell = tableView.dequeueReusableCell(withIdentifier: CHART_CELL_ID, for: indexPath) as! RecordDetailChartCell
            cell.initLineChart(drivingRecord)
            cell.initBarChart(drivingRecord)
            return cell

        } else if indexPath.section == SECTION_DISTRACTION_SUMMARY{
            //SECTION_DISTRACTION_SUMMARY
            let cell = tableView.dequeueReusableCell(withIdentifier: DISTRACTION_CELL_ID, for: indexPath) as! RecordDetailDistractionSummaryCell
            if let delegate = UIApplication.shared.delegate as? AppDelegate, let databaseController = delegate.firebaseController, let id = self.drivingRecord?.id{
                cell.dataSource = databaseController.getFacialRecordByRecordId(id).filter({(facial) in
                    let detail = facial.faceDetails
                    if detail.count > 0{
                        let firstEmotion = detail[0]
                        if firstEmotion.emotions[0].type == "CALM"{
                            return false
                        }
                    }else{
                        return false
                    }
                    return true
                })
            }
            cell.delegateParent = self
            return cell
        }else if indexPath.section == SECTION_OVER_SPEED_SUMMARY{
            let cell = tableView.dequeueReusableCell(withIdentifier: OVER_SPEED_CELL_ID,for: indexPath) as! RecordDeailOverSpeedTableViewCell
            guard let delegate = UIApplication.shared.delegate as? AppDelegate, let databaseController = delegate.firebaseController, let id = self.drivingRecord?.id else {
                return cell
            }
            let data = databaseController.getSpeedRecordByRecordId(id).filter({(record) in record.overSpeed})
            cell.dataSource = data
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
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
        recordDetailTableView.deselectRow(at:indexPath,animated:true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DISTRACTION_DETAIL_PAGE_SEGUE {
            if let des = segue.destination as? DistractionDetailViewController{
                let data = sender as? ((locationName: String, facialInfo: FacialInfo, type: DetailType))
                des.selectedDistractionRecord = data?.1
                des.selectedDistractionLocationName = data?.0
                des.detailType = data?.2
            }
        }
    }
}

// MARK: - RecordBreakdownDelegate
extension RecordDetailViewController:  RecordDetailDistractionSummaryCellDelegate  {
    func jumpToSelectedRowDetailPage(selectedRow: (locationName: String, facialInfo: FacialInfo, type: DetailType)){
        performSegue(withIdentifier: DISTRACTION_DETAIL_PAGE_SEGUE, sender: selectedRow)
    }
}
