//
//  DistractionDetailCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/13.
//

import UIKit

class DistractionDetailCell: UITableViewCell {
    static let identifier = "DistractionDetailCell"
    static func nib()->UINib{
        return UINib(nibName: "DistractionDetailCell", bundle: nil)
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