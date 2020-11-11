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
}

class RoadInfoBottomCard : UIViewController, UITableViewDelegate, UITableViewDataSource,ScrollableViewController, DatabaseListener {
    var listenerType: ListenerType = .selectedRoad
    
    
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
        areaOutlet = roadInfoBottomCardHandleAreaOutlet
        selectedRoadTableView.delegate = self
        selectedRoadTableView.dataSource = self
        selectedRoadTableView.register(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL_ID)
        selectedRoadTableView.register(BottomCardImportantRoadCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)
        //        searchAddressBottomCardTableViewOutlet.register(UINib(nibName: "nibFileName", bundle: nil), forCellReuseIdentifier: "CellFromNib")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseProtocol = appDelegate?.firebaseController
        databaseProtocol?.addListener(listener: self)
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        databaseProtocol?.removeListener(listener: self)
        databaseProtocol = nil

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
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
            selectedRoadTableView.deselectRow(at:indexPath,animated:true)
        }
        if indexPath.section == SECTION_CONTENT{
            //这里传值以后需要改下
            self.delegateParent?.jumpToSelectedRowDetailPage(selectedRow: selectRoadDataSource[indexPath.row])
        }
    }

    
    func onSelectedRoadInfoChange(change: DatabaseChange, selectRoads: [UserSelectedRoadResponse]) {
        self.selectRoadDataSource = selectRoads
        self.selectedRoadTableView.reloadSections([SECTION_CONTENT], with: .automatic)
    }
}




