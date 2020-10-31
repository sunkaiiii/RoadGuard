//
//  BottomCardSpecifyCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/25.
//

import UIKit

class BottomCardSpecifyCell: UITableViewCell {

    @IBOutlet var iconImageView : UIImageView!
    @IBOutlet var headerLabel : UILabel!
    @IBOutlet var contentLabel : UILabel!
    @IBOutlet var distanceLabel : UILabel!

    static let identifier = "BottomCardSpecifyCell"
    static func nib()->UINib{
        return UINib(nibName: "BottomCardSpecifyCell", bundle: nil)
    }

    public func configure(iconImageViewName: String,headerLabel: String, contentLabel: String, distanceLabel: String){
        self.iconImageView.image = UIImage(systemName: iconImageViewName)
        self.headerLabel.text = headerLabel
        self.contentLabel.text = contentLabel
        self.distanceLabel.text = distanceLabel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.contentMode = .scaleAspectFit
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
