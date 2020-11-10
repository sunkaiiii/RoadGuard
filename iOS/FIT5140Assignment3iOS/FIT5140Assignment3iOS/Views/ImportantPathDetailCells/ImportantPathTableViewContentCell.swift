//
//  ImportantPathTableViewContentCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/10.
//

import UIKit

class ImportantPathTableViewContentCell: UITableViewCell {

    @IBOutlet weak var roadNameLabel: UILabel!
    @IBOutlet weak var meterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
