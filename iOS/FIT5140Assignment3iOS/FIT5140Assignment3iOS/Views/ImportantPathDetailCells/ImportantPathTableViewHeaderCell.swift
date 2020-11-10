//
//  ImportantPathTableViewHeaderCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/10.
//

import UIKit

class ImportantPathTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var pathDetailCellVIsualEffectView: UIVisualEffectView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var editIconOutlet: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let blurEffect = UIBlurEffect(style: .light)
        pathDetailCellVIsualEffectView.effect = blurEffect
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
