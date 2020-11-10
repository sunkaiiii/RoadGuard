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
    @IBOutlet weak var addRoadBtn: UIImageView!
    
    private var roadDetail:RoadInformation?
    var delegate:BottomCardSpeicifyCellDelegate?
    private var isAdded = false
    
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
        roadDetail = RoadInforamtionImpl(placeID: placeDetail.placeID, name: placeDetail.name, formatName: placeDetail.formattedAddress, latitude: placeDetail.geometry.location.lat, longitude: placeDetail.geometry.location.lng, icon: placeDetail.icon)
        initImageClick()
    }
    
    func initWithSearchRestul(_ placeDetail:SearchPlaceDetail){
        headerLabel.text = placeDetail.name
        contentLabel.text = placeDetail.formattedAddress
        ImageLoader.simpleLoad(placeDetail.icon, imageView: iconImageView)
        roadDetail = RoadInforamtionImpl(placeID: placeDetail.placeID, name: placeDetail.name, formatName: placeDetail.formattedAddress, latitude: placeDetail.geometry.location.lat, longitude: placeDetail.geometry.location.lng, icon: placeDetail.icon)
        initImageClick()
    }
    
    func initImageClick(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addButtonTapped(tapGesture:)))
        addRoadBtn.isUserInteractionEnabled = true
        addRoadBtn.addGestureRecognizer(tapGesture)
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
    
    //assign action to UIImageView references on https://stackoverflow.com/questions/27880607/how-to-assign-an-action-for-uiimageview-object-in-swift
    @objc func addButtonTapped(tapGesture:UITapGestureRecognizer)
    {
        guard let detail = roadDetail, let imageView = tapGesture.view as? UIImageView else {
            return
        }
        if isAdded{
            delegate?.removeRoad(roadInfo: detail)
            imageView.image = UIImage(named: "AddRoad")
        }else{
            delegate?.addRoad(roadInfo: detail)
            imageView.image = UIImage(named: "RemoveRoad")
        }
        
        isAdded != isAdded
    }
    
    private struct RoadInforamtionImpl:RoadInformation{
        let placeID:String
         
        let name: String
        
        let formatName: String
        
        let latitude: Double
        
        let longitude: Double
        
        let icon: String?
        
    }
}



protocol RoadInformation {
    var placeID:String{get}
    var name:String{get}
    var formatName:String{get}
    var latitude:Double{get}
    var longitude:Double{get}
    var icon:String?{get}
}

protocol BottomCardSpeicifyCellDelegate {
    func addRoad(roadInfo:RoadInformation)
    func removeRoad(roadInfo:RoadInformation)
}
