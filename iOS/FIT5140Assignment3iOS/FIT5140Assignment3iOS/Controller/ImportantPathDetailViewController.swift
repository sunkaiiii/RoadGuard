//
//  ImportantPathDetailViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/9.
//

import UIKit
import GoogleMaps


class ImportantPathDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var visualEffectForTablViewBackground: UIVisualEffectView!
    @IBOutlet weak var totalLengthNumberLabel: UILabel!
    @IBOutlet weak var passTimesLabel: UILabel!
    @IBOutlet weak var importantPathTableView: UITableView!
    @IBOutlet weak var importantPathGoogleMapView: GMSMapView!

    @IBOutlet weak var totalLengthVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var passTimesVisualEffectView: UIVisualEffectView!
    var actionOptions: UIAlertController?
    var deleteOption:UIAlertController?

    let SECTION_HEADER = 0
    let SECTION_CONTENT = 1
    let HEADER_CELL_ID = "importantPathDetailTableViewHeaderCell"
    let CONTENT_CELL_ID = "importantPathDetailTableViewContentCell"

    
    var selectedRoad:UserSelectedRoadResponse?
    var roadsInfo:[RoadInformationDataSource] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        importantPathTableView.delegate = self
        importantPathTableView.dataSource = self
        initViews()
        initTopTableData()
        initGoogleMap()
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_HEADER:
                return 1
            case SECTION_CONTENT:
                return roadsInfo.count
            default:
                return 1
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == SECTION_HEADER {
            let cell = tableView.dequeueReusableCell(withIdentifier: HEADER_CELL_ID, for: indexPath) as! ImportantPathTableViewHeaderCell
            cell.headerLabel.text = selectedRoad?.selectedRoadCustomName
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editIconOnClick(_:)))
            gestureRecognizer.numberOfTapsRequired = 1
            gestureRecognizer.numberOfTouchesRequired = 1
            cell.editIconOutlet.addGestureRecognizer(gestureRecognizer)
            cell.editIconOutlet.isUserInteractionEnabled = true
            return cell
        }else{
            //content section
            let cell = tableView.dequeueReusableCell(withIdentifier: CONTENT_CELL_ID, for: indexPath) as! ImportantPathTableViewContentCell
            let road = roadsInfo[indexPath.row]
            cell.handleWithPlaceId(road)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_HEADER{
            return false
        }
        return true
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        importantPathTableView.deselectRow(at:indexPath,animated:true)
    }

    // MARK: - Gesture Action
    @objc func editIconOnClick(_ gestureRecognizer: UITapGestureRecognizer){


        actionOptions = UIAlertController(title: "Chose an Option", message: "", preferredStyle: .actionSheet)

        actionOptions?.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
            self.deleteOption = UIAlertController(title: "Do you want to delete?", message: "", preferredStyle: .actionSheet)
            self.deleteOption?.addAction(UIAlertAction(title: "Delete", style: .default, handler: {(action) in
                if let controller = (UIApplication.shared.delegate as? AppDelegate)?.firebaseController,let id = self.selectedRoad?.id{
                    controller.deleteSelectedRoadById(id)
                    self.showToast(message: "Delete a road successfully")
                    self.navigationController?.popViewController(animated: true)
                }

            }))
            self.deleteOption?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                
            }))
            if let delete = self.deleteOption{
                self.present(delete, animated: true)
            }
            
        }))
        actionOptions?.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction) in
            //what to do after clicking
        }))
        actionOptions?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let action = actionOptions{
            self.present(action,animated: true)
        }
        
    }

}


struct RoadInformationDataSource {
    let placeId:String
    let length:Double
}
