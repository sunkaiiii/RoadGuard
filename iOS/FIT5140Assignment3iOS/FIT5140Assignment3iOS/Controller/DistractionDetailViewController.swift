//
//  DistractionDetailViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/13.
//

import UIKit
import GoogleMaps

class DistractionDetailViewController: UIViewController {

    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var roadNameLabel: UILabel!
    @IBOutlet weak var distractionTimeLabel: UILabel!
    @IBOutlet weak var mapAreaBackgroundVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var overSpeedLegendIcon: UIView!
    @IBOutlet weak var distractionLegendIcon: UIView!
    @IBOutlet weak var bodyMotionLegendIcon: UIView!
    @IBOutlet weak var speedAlertView: SpeedAlertSuperView!
    @IBOutlet weak var speedLimitView: DistractionSpeedLimitSuperView!

    var mapview:GMSMapView?
    //需要改为传入的值
    var selectedDistractionRecord : String = "abc"
    
    override func viewDidLoad() {
        super.viewDidLoad()


        //Todo 需要写个判断，根据传入的数据，判断是什么情况，如果是超速，则设为红色背景
        speedAlertView.setSignBackgroundColor(situation: .overSpeed)

        //Todo 需要写个判断，根据传入的数据，判断是什么情况，决定用什么图片

        mapViewContainer.layer.cornerRadius = 24
        mapAreaBackgroundVisualEffectView.layer.cornerRadius = 24
        mapAreaBackgroundVisualEffectView.contentView.layer.cornerRadius = 24
        overSpeedLegendIcon.layer.cornerRadius = overSpeedLegendIcon.bounds.size.width/2
        distractionLegendIcon.layer.cornerRadius = distractionLegendIcon.bounds.size.width/2
        bodyMotionLegendIcon.layer.cornerRadius = bodyMotionLegendIcon.bounds.size.width/2
        overSpeedLegendIcon.layer.masksToBounds = true
        distractionLegendIcon.layer.masksToBounds = true
        bodyMotionLegendIcon.layer.masksToBounds = true

        initGoogleMap()
    }
    

    func initGoogleMap(){
        let gmsCamera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapview = GMSMapView.map(withFrame: self.view.frame, camera: gmsCamera)
        if let mapview = mapview{
            self.mapViewContainer.addSubview(mapview)
            mapview.layer.zPosition = -.greatestFiniteMagnitude
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
