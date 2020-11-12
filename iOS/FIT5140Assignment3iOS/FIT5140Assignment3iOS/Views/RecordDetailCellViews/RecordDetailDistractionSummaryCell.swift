//
//  RecordDetailDistractionSummaryCell.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/11/12.
//

import UIKit

class RecordDetailDistractionSummaryCell: UITableViewCell , UITableViewDelegate, UITableViewDataSource{


    @IBOutlet weak var backgroundVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var distractionTableView: UITableView!
    //需更改数据源
    var dataSource : [String] = ["1","1","1","1","1","1","1","1","1"]
    let CELL_ID = DistractionDetailCell.identifier


    static let identifier = "RecordDetailDistractionSummaryCell"
    static func nib()->UINib{
        return UINib(nibName: "RecordDetailDistractionSummaryCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        distractionTableView.delegate = self
        distractionTableView.dataSource = self
        distractionTableView.register(DistractionDetailCell.nib(), forCellReuseIdentifier: CELL_ID)

        backgroundVisualEffectView.layer.cornerRadius = 24
        backgroundVisualEffectView.contentView.layer.cornerRadius = 24
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! DistractionDetailCell
        //给cell传值
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        //跳转
        //需借助delegate让母视图的母视图跳转
        //考虑从这里点击跳转 还是母tableView点击跳转
        tableView.deselectRow(at:indexPath,animated:true)
    }

}
