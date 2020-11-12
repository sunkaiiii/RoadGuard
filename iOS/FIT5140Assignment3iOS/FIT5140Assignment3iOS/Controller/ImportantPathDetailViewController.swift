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
    

    let SECTION_HEADER = 0
    let SECTION_CONTENT = 1
    let HEADER_CELL_ID = "importantPathDetailTableViewHeaderCell"
    let CONTENT_CELL_ID = "importantPathDetailTableViewContentCell"

    
    var selectedRoad:UserSelectedRoadResponse?
    var roads:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        importantPathTableView.delegate = self
        importantPathTableView.dataSource = self
        initViews()
        initData(selectedRoad)
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
                return roads.count
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
            let placeId = roads[indexPath.row]
            cell.handleWithPlaceId(placeId)
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

        //TODO，icon触发事件有待更新，现在只是放个dummy的在这测试用

        let actionOptions = UIAlertController(title: "Chose a User", message: "Chose a User", preferredStyle: .actionSheet)
        //这里考虑写个循环 根据用户数量添加
        actionOptions.addAction(UIAlertAction(title: "User1", style: .default, handler: { (action: UIAlertAction) in
            //what to do after clicking
        }))
        actionOptions.addAction(UIAlertAction(title: "User2", style: .default, handler: { (action: UIAlertAction) in
            //what to do after clicking
        }))
        actionOptions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionOptions,animated: true)


    }



}
