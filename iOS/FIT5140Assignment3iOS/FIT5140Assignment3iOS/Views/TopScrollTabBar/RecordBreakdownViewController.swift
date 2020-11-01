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
    let TABLE_HEADER_CELL_ID = RecordPageHeaderTableViewCell.identifier
    let TABLE_CONTENT_CELL_ID = RecordBkdTableViewCell.identifier
    
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
        table.register(RecordPageHeaderTableViewCell.nib(), forCellReuseIdentifier: TABLE_HEADER_CELL_ID)
        table.register(RecordBkdTableViewCell.nib(), forCellReuseIdentifier: TABLE_CONTENT_CELL_ID)

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
            let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_HEADER_CELL_ID, for: indexPath) as! RecordPageHeaderTableViewCell
            //setting up single click gesture to the slider button
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showFilterOptions(_:)))
            gestureRecognizer.numberOfTapsRequired = 1
            gestureRecognizer.numberOfTouchesRequired = 1
            cell.sliderButtonOutlet.addGestureRecognizer(gestureRecognizer)
            cell.sliderButtonOutlet.isUserInteractionEnabled = true
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_CONTENT_CELL_ID, for: indexPath) as! RecordBkdTableViewCell
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

    @objc func showFilterOptions(_ gestureRecognizer: UITapGestureRecognizer){
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
