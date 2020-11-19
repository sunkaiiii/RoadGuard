//
//  RecordDetailDistractionSummaryCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit
protocol RecordDetailDistractionSummaryCellDelegate: class {
    func jumpToSelectedRowDetailPage(selectedRow: (locationName: String, facialInfo: FacialInfo))
}


class RecordDetailDistractionSummaryCell: UITableViewCell , UITableViewDelegate, UITableViewDataSource{

    var selectedDistractionInfo: (locationName: String, facialInfo: FacialInfo)?


    weak var delegateParent: RecordDetailDistractionSummaryCellDelegate?


    @IBOutlet weak var backgroundVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var distractionTableView: UITableView!
    //需更改数据源
    var dataSource : [FacialInfo] = []
    let CELL_ID = DistractionDetailCell.identifier


    static let identifier = "RecordDetailDistractionSummaryCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailDistractionSummaryCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        distractionTableView.delegate = self
        distractionTableView.dataSource = self
        distractionTableView.register(DistractionDetailCell.nib(), forCellReuseIdentifier: CELL_ID)

        backgroundVisualEffectView.layer.cornerRadius = 24
        backgroundVisualEffectView.contentView.layer.cornerRadius = 24
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
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! DistractionDetailCell
        let facialInfo = dataSource[indexPath.row]
//        cell.delegate = self
        cell.initDistractionDetail(facialInfo)
        //给cell传值
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        //跳转
        let cell = tableView.cellForRow(at: indexPath) as! DistractionDetailCell

        let distractionPlaceName = cell.distractionPlaceName
        delegateParent?.jumpToSelectedRowDetailPage(selectedRow:(locationName: distractionPlaceName!, facialInfo: dataSource[indexPath.row]) )
        tableView.deselectRow(at:indexPath,animated:true)
    }

}
