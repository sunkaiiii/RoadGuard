//
//  RecordBreakdownViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/31.
//

import UIKit

class RecordBreakdownViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var table:UITableView!

    let SECTION_HEADER = 0
    let SECTION_CONTENT = 1
    //这里需要换成customer cell 暂时先放default
    let DEFAULT_CELL_ID = "DefaultCell"
    let BOTTOM_CARD_CELL_ID = RecordBkdTableViewCell.identifier
    
    //根据需要展示的内容，更改数据类型和内容
    var tableViewDataSource = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry",
                  "Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit",
                  "Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango",
                  "Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach",
                  "Pear", "Pineapple", "Raspberry", "Strawberry"]

    override func viewDidLoad() {
        super.viewDidLoad()
        table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear

        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: DEFAULT_CELL_ID)
        table.register(RecordBkdTableViewCell.nib(), forCellReuseIdentifier: BOTTOM_CARD_CELL_ID)

        self.view.addSubview(table)
        let widthConstraint  = NSLayoutConstraint(item: table!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: table!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        view.addConstraints([widthConstraint, heightConstraint])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_HEADER:
                return 1
            case SECTION_CONTENT:
                return tableViewDataSource.count
            default:
                return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_HEADER {
            //这里需要换成customer cell 暂时先放default
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = "History"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: BOTTOM_CARD_CELL_ID, for: indexPath) as! RecordBkdTableViewCell
            //调用cell.configure给图片和label赋值
            cell.iconImageOutlet.image = UIImage(systemName: "person.crop.circle")
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
            table.deselectRow(at:indexPath,animated:true)}
    }

}
