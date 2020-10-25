//
//  SearchAddressBottomCard.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/24.
//

import Foundation
import UIKit

class SearchAddressBottomCard : UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchAddressBottomCardHandleAreaOutlet: UIView!

    @IBOutlet weak var searchAddressBottomCardTableViewOutlet: UITableView!

    let SECTION_HEADER_SPECIFY = 0
    let SECTION_CONTENT_SPECIFY = 1
    let SECTION_HEADER_NEARBY = 2
    let SECTION_CONTENT_NEARBY = 3
    let DEFAULT_CELL_ID = "DefaultCell"
    let BOTTOM_CARD_CELL_ID = BottomCardSpecifyCell.identifier

    //根据需要展示的内容，更改数据类型和内容
    var tableViewDataSourceSpecify : [String]  = ["d","e","f"]
    var tableViewDataSourceNearby : [String] =  ["d","e","f"]

    override func viewDidLoad() {
        super.viewDidLoad()
        searchAddressBottomCardTableViewOutlet.delegate = self
        searchAddressBottomCardTableViewOutlet.dataSource = self
        searchAddressBottomCardTableViewOutlet.register(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL_ID)
        searchAddressBottomCardTableViewOutlet.register(BottomCardSpecifyCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)
        //        searchAddressBottomCardTableViewOutlet.register(UINib(nibName: "nibFileName", bundle: nil), forCellReuseIdentifier: "CellFromNib")
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
            case SECTION_HEADER_SPECIFY:
                return 1
            case SECTION_CONTENT_SPECIFY:
                return tableViewDataSourceSpecify.count
            case SECTION_HEADER_NEARBY:
                return 1
            case SECTION_CONTENT_NEARBY:
                return tableViewDataSourceNearby.count
            default:
                return 1
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_HEADER_SPECIFY {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "Specify"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            return cell
        }
        else if indexPath.section == SECTION_HEADER_NEARBY {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.textLabel?.text = "Nearby"
            return cell
        } else if indexPath.section == SECTION_CONTENT_SPECIFY {
            let cell = tableView.dequeueReusableCell(withIdentifier: BOTTOM_CARD_CELL_ID, for: indexPath) as! BottomCardSpecifyCell
            //调用cell.configure给图片和label赋值
            cell.iconImageView.image = UIImage(systemName: "mappin.circle.fill")
            return cell
        } else {
            //for nearby-content section
            let cell = tableView.dequeueReusableCell(withIdentifier: BOTTOM_CARD_CELL_ID, for: indexPath) as! BottomCardSpecifyCell
            //调用cell.configure给图片和label赋值
            cell.iconImageView.image = UIImage(systemName: "plus")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_HEADER_SPECIFY {
            return 50
        } else if indexPath.section == SECTION_HEADER_NEARBY {
            return 50
        } else {
            return 80
        }
    }
}




