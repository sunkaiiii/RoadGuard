//
//  RoadInfoBottomCard.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/25.
//

import Foundation
import UIKit
import MapKit

protocol RoadInfoBottomCardDelegate: class {
    //这里回头需要改下传值的类型
    func jumpToSelectedRowDetailPage(selectedRow: UserSelectedRoadResponse)
    func calculateTotalNumberAndDistance(roadRecords: [UserSelectedRoadResponse])
}

class RoadInfoBottomCard : UIViewController, UITableViewDelegate, UITableViewDataSource,ScrollableViewController, DatabaseListener {
    var listenerType: [ListenerType] = [ListenerType.selectedRoad]
    
    
    var areaOutlet: UIView?
    weak var delegateParent: RoadInfoBottomCardDelegate?
    
    @IBOutlet weak var roadInfoBottomCardHandleAreaOutlet: UIView!
    @IBOutlet weak var selectedRoadTableView: UITableView!

    let SECTION_HEADER = 0
    let SECTION_CONTENT = 1
    let DEFAULT_CELL_ID = "DefaultCell"
    let BOTTOM_CARD_CELL_ID = BottomCardImportantRoadCell.identifier

    //根据需要展示的内容，更改数据类型和内容
    var selectRoadDataSource : [UserSelectedRoadResponse]  = []
    weak var databaseProtocol:DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseProtocol = appDelegate?.firebaseController
        databaseProtocol?.addListener(listener: self)
        areaOutlet = roadInfoBottomCardHandleAreaOutlet
        selectedRoadTableView.register(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL_ID)
        selectedRoadTableView.register(BottomCardImportantRoadCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)
        selectedRoadTableView.delegate = self
        selectedRoadTableView.dataSource = self
    }

    
    override func removeFromParent() {
        super.removeFromParent()
        databaseProtocol?.removeListener(listener: self)
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
                return selectRoadDataSource.count
            default:
                return 1
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_HEADER {
            let cell = tableView.dequeueReusableCell(withIdentifier: DEFAULT_CELL_ID, for: indexPath)
            cell.textLabel?.text = "Important Roads"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            return cell
        } else {
            //for content section
            let cell = tableView.dequeueReusableCell(withIdentifier: BOTTOM_CARD_CELL_ID, for: indexPath) as! BottomCardImportantRoadCell
            let selectedRoad = selectRoadDataSource[indexPath.row]
            cell.initWithSelectedRoadData(selectedRoad)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_HEADER {
            return 50
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_HEADER{
            return false
        }
        return true
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_HEADER{
            tableView.deselectRow(at:indexPath,animated:true)
        }
        if indexPath.section == SECTION_CONTENT{
            self.delegateParent?.jumpToSelectedRowDetailPage(selectedRow: selectRoadDataSource[indexPath.row])
            tableView.deselectRow(at:indexPath,animated:true)
        }
    }

    func askDelegateToCalculateTotalNumberAndDistance(){
        self.delegateParent?.calculateTotalNumberAndDistance(roadRecords: self.selectRoadDataSource)
    }

    // MARK: - DB Listening
    func onSelectedRoadInfoChange(change: DatabaseChange, selectRoads: [UserSelectedRoadResponse]) {
        self.selectRoadDataSource = selectRoads
        askDelegateToCalculateTotalNumberAndDistance()
        self.selectedRoadTableView.reloadSections([SECTION_CONTENT], with: .automatic)
    }    

}




