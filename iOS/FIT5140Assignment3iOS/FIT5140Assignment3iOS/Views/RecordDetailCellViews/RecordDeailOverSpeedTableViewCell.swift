//
//  RecordDeailOverSpeedTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 21/11/20.
//

import UIKit

class RecordDeailOverSpeedTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var backgroundVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var overspeedTableView: UITableView!
    var delegate:RecordDetailDistractionSummaryCellDelegate?
    var dataSource:[SpeedRecord] = []
    static let identifier = "RecordDeailOverSpeedTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDeailOverSpeedTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        overspeedTableView.delegate = self
        overspeedTableView.dataSource = self
        overspeedTableView.register(RecordDetailOverspeedDetailTableViewCell.nib(), forCellReuseIdentifier: RecordDetailOverspeedDetailTableViewCell.identifier)
        backgroundVisualEffectView.layer.cornerRadius = 24
        backgroundVisualEffectView.contentView.layer.cornerRadius = 24
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordDetailOverspeedDetailTableViewCell.identifier) as! RecordDetailOverspeedDetailTableViewCell
        
        let overSpeedInfo = dataSource[indexPath.row]
        cell.initwithSpeedRecord(overSpeedInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RecordDetailOverspeedDetailTableViewCell
        let selectedRecord = dataSource[indexPath.row]
        let placeName = cell.placeName
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate, let databaseController = appdelegate.firebaseController,let facialId = selectedRecord.facialId, let facialInfo = databaseController.getFacialRecordById(facialId) else {
            return
        }
        
        delegate?.jumpToSelectedRowDetailPage(selectedRow: (placeName,facialInfo))
    }

    
    
}
