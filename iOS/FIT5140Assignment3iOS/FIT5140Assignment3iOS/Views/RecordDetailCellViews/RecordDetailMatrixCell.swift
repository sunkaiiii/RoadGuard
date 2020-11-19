//
//  RecordDetailMatrixCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit

class RecordDetailMatrixCell: UITableViewCell {
    @IBOutlet weak var backgroundVisualEffectView: UIVisualEffectView!

    @IBOutlet weak var totalLengthLabel: UILabel!
    @IBOutlet weak var distractionTimesLabel: UILabel!
    
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var drivingDurationLabel: UILabel!
    weak var databaseController:DatabaseProtocol?
    static let identifier = "RecordDetailMatrixCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailMatrixCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let blurEffect = UIBlurEffect(style: .light)
//        backgroundVisualEffectView.effect = blurEffect
        backgroundVisualEffectView.layer.cornerRadius = 24
        backgroundVisualEffectView.contentView.layer.cornerRadius = 24

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func didMoveToSuperview() {
        let appDelegat = UIApplication.shared.delegate as? AppDelegate
        self.databaseController = appDelegat?.firebaseController
    }
    
    override func removeFromSuperview() {
        self.databaseController = nil
    }
    
    func initMatrixData(_ drivingRecord:DrivingRecordResponse?){
        guard let drivingRecord = drivingRecord, let databaseController = databaseController, let id = drivingRecord.id else {
            return
        }
        totalLengthLabel.text = String(format: "%.2f", drivingRecord.drivingDistance/1000.0)+"KM"
        drivingDurationLabel.text = String(format: "%.0f", drivingRecord.endTime.timeIntervalSince(drivingRecord.startTime)/60) + " min"
        let speedList = databaseController.getSpeedRecordByRecordId(id)
        let sumSpeed = speedList.map({(speedInfo) in speedInfo.currentSpeed}).reduce(0,+)
        if speedList.count > 0{
            avgSpeedLabel.text = "\(sumSpeed/speedList.count)"
        }else{
            avgSpeedLabel.text = "Unknown"
        }
        
        let facialList = databaseController.getFacialRecordByRecordId(id)
        let time = facialList.filter({(facial) in
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
        }).count
        distractionTimesLabel.text = "\(time)"
    }
}
