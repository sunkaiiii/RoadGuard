//
//  RecordPageHeaderTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/1.
//

import UIKit

class RecordPageHeaderTableViewCell: UITableViewCell {
    static let identifier = "RecordPageHeaderTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordPageHeaderTableViewCell", bundle: nil)
    }

    @IBOutlet weak var sliderButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
