//
//  RecordDetailDistractionSummaryCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit

class RecordDetailDistractionSummaryCell: UITableViewCell {
    static let identifier = "RecordDetailDistractionSummaryCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailDistractionSummaryCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
