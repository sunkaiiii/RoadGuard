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
    
    func initWithPlaceDetail(_ placeDetail:PlaceDetail){
        headerLabel.text = placeDetail.name
        var subContent = ""
        placeDetail.addressComponents.forEach{(component) in
            if component.types.contains("locality") || component.types.contains("postal_code") || component.types.contains("administrative_area_level_1"){
                subContent += component.shortName + " "
            }
        }
        contentLabel.text = subContent
        ImageLoader.simpleLoad(placeDetail.icon, imageView: iconImageView)
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
