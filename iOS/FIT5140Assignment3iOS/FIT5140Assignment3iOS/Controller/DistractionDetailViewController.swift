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
    @IBOutlet weak var topCircle: UIView!
    @IBOutlet weak var midlleCircle: UIView!
    @IBOutlet weak var bottomCicrle: UIView!
    @IBOutlet weak var speedAlertView: SpeedAlertSuperView!
    @IBOutlet weak var speedLimitView: DistractionSpeedLimitSuperView!

    @IBOutlet weak var topCircleLabel: UILabel!
    @IBOutlet weak var middleCircleLabel: UILabel!
    @IBOutlet weak var bottomCircleLabel: UILabel!
    
    var mapview:GMSMapView?
    

    var selectedDistractionLocationName : String?
    var selectedDistractionRecord : FacialInfo?
    var detailType:DetailType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewContainer.layer.cornerRadius = 24
        mapAreaBackgroundVisualEffectView.layer.cornerRadius = 24
        mapAreaBackgroundVisualEffectView.contentView.layer.cornerRadius = 24
        topCircle.layer.cornerRadius = topCircle.bounds.size.width/2
        midlleCircle.layer.cornerRadius = midlleCircle.bounds.size.width/2
        bottomCicrle.layer.cornerRadius = bottomCicrle.bounds.size.width/2
        topCircle.layer.masksToBounds = true
        midlleCircle.layer.masksToBounds = true
        bottomCicrle.layer.masksToBounds = true


        if selectedDistractionRecord != nil{
            //Todo, 路名还没传入? roadname label
            roadNameLabel.text = selectedDistractionLocationName

            //set time label
            let formatter = DateFormatter()
            formatter.timeZone = .current
            formatter.locale = .current
            formatter.dateFormat = "hh:mm a dd-MMM-yyyy"
            distractionTimeLabel.text = formatter.string(from: selectedDistractionRecord!.capturedTime)

            //set three label
            var emotions = selectedDistractionRecord?.faceDetails.first?.emotions
            emotions?.sort(by: { (thisEmotion: Emotion, thatEmotion: Emotion) -> Bool in
                return thisEmotion.confidence > thatEmotion.confidence
            })

            var counter = 0
            let skipText:String
            if detailType == DetailType.distraction{
                skipText = "CALM"
            }else{
                skipText = ""
            }
            for element in emotions!{
                if element.type != skipText {
                    switch counter {
                        case 0:
                            topCircleLabel.text = element.type
                        case 1:
                            middleCircleLabel.text = element.type
                        case 2:
                            bottomCircleLabel.text = element.type
                        default:
                            break
                    }
                    counter += 1
                }
            }

            //set current speed text
            let speed = selectedDistractionRecord!.speed
            if speed >= 0 {
                let speedString = String(Int(speed))
                speedAlertView.setCurrentSpeed(speed: speedString)
            } else {
                speedAlertView.setCurrentSpeed(speed: "N/A")
            }
            speedAlertView.setLabelFontSize(size: 16)

            //set speed limit text
            let limitedSpeed = selectedDistractionRecord?.speedLimit ?? nil
            if let limitedSpeed = limitedSpeed , limitedSpeed >= 0 {
                speedLimitView.setSpeedLimit(speed: String(Int(limitedSpeed)))
            } else {
                speedLimitView.setSpeedLimit(speed: "N/A")
            }

            //when overspeed, set the sign background as red; otherwise, green
            if let limitedSpeed = limitedSpeed,limitedSpeed >= 0, speed >= 0{
                if speed > limitedSpeed{
                    speedAlertView.setSignBackgroundColor(situation: .overSpeed)
                } else {
                    speedAlertView.setSignBackgroundColor(situation: .safeSpeed)
                }
            }

            //get captured image
            ImageLoader.simpleLoad(selectedDistractionRecord?.imageURL, imageView: topImage)
        }

        if detailType != nil, detailType! == .overspeed{
            self.navigationItem.title = "Overspeed Detail"
        }

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

enum DetailType{
    case distraction
    case overspeed
}
