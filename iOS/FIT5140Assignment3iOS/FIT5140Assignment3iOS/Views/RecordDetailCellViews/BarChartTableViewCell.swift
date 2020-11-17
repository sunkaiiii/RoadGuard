//
//  BarChartTableViewCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/16.
//

import UIKit

class BarChartTableViewCell: UITableViewCell {
    static let identifier = "BarChartTableViewCell"
    static func nib()->UINib{
        return UINib(nibName: "BarChartTableViewCell", bundle: nil)
    }

    @IBOutlet weak var backgroundVisualEffect: UIVisualEffectView!
    
    @IBOutlet weak var streetNameLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var barWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
