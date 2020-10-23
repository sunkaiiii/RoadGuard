//
//  SpeedAlertView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 22/10/20.
//

import UIKit

@IBDesignable class SpeedAlertView: UIView {
    @IBOutlet weak var speedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addXibView()
    }
    
    func addXibView(){
        if let speedAlertView = Bundle(for: SpeedAlertView.self).loadNibNamed("\(SpeedAlertView.self)", owner: nil, options: nil)?.first as? UIView{
            self.addSubview(speedAlertView)
            speedAlertView.frame=bounds
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addXibView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width/2
        layer.masksToBounds = true
    }
}
