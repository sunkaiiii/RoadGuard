//
//  RecordViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/30.
//

import UIKit


class RecordViewController: UIViewController, WormTabStripDelegate, DatabaseListener{
    var listenerType: [ListenerType] = [ListenerType.drivingRecord]
    

    let DETAIL_PAGE_SEGUE_ID = "recordDetailSegue"

    @IBOutlet weak var viewPager: WormTabStrip!
    
    // MARK: - Top Scroll Tab Bar Related Fields
    var tabContentViews:[UIViewController] = []
    //这里需要根据传入的record数据，替换下这个数组
    //需要传入带月份信息的 record对象
    var montlyRecords : [String]  = []
    var dataSource:[Int:[DrivingRecordResponse]] = [:]

    // MARK: - Top Scroll Tab Bar Related functions
    func setUpContentViewForEachTab(){
        montlyRecords.removeAll()
        for index in 1...12 {
            montlyRecords.append(Calendar.current.monthSymbols[index-1])
            let vc = RecordBreakdownViewController()
            vc.delegateParent = self
            vc.monthIndex = index
            vc.tableViewDataSource = self.dataSource[index] ?? []
            tabContentViews.append(vc)
        }
    }

    //This is from https://github.com/EzimetYusup/WormTabStrip
    func setUpViewPager(){
        viewPager.delegate = self
        viewPager.eyStyle.wormStyel = .line
        viewPager.eyStyle.isWormEnable = true
        viewPager.eyStyle.spacingBetweenTabs = 15
        viewPager.eyStyle.dividerBackgroundColor = .white
        viewPager.eyStyle.WormColor = .blue
        viewPager.eyStyle.tabItemDefaultColor = .blue
        viewPager.eyStyle.tabItemSelectedColor = .blue
        viewPager.eyStyle.topScrollViewBackgroundColor = .white
        viewPager.eyStyle.tabItemDefaultFont = UIFont.boldSystemFont(ofSize: 16.0)
        viewPager.eyStyle.tabItemSelectedFont = UIFont.boldSystemFont(ofSize: 16.0)
        viewPager.currentTabIndex = Calendar.current.component(.month, from: Date()) - 1 //get current month number refereces on https://stackoverflow.com/questions/55492003/how-can-i-find-current-month-name-and-current-month-number-in-swift
        viewPager.buildUI()
    }

    func wtsNumberOfTabs() -> Int {
        return montlyRecords.count
    }

    func wtsViewOfTab(index: Int) -> UIView {
        return tabContentViews[index].view
    }

    func wtsTitleForTab(index: Int) -> String {
        return montlyRecords[index]
    }

    func wtsDidSelectTab(index: Int) {
        //
    }

    func wtsReachedLeftEdge(panParam: UIPanGestureRecognizer) {
        //
    }

    func wtsReachedRightEdge(panParam: UIPanGestureRecognizer) {
        //
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpContentViewForEachTab()
//        setUpViewPager()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.firebaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.firebaseController?.removeListener(listener: self)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DETAIL_PAGE_SEGUE_ID {
            if let des = segue.destination as? RecordDetailViewController, let respone = sender as? DrivingRecordResponse{
                //需要改传值类型
                des.drivingRecord = respone
            }

        }
    }
    
    
    func onDrivingRecordChange(change: DatabaseChange, drivingRecord: [DrivingRecordResponse]) {
        //map array into a group of dictionary, references on https://stackoverflow.com/questions/38454952/map-array-of-objects-to-dictionary-in-swift
        self.dataSource = drivingRecord.reduce([Int:[DrivingRecordResponse]]()){(dict,drivingRecord)->[Int:[DrivingRecordResponse]] in
            var dict = dict
            let index = Calendar.current.component(.month, from: drivingRecord.startTime)
            if dict[index] == nil{
                dict[index] = []
            }
            dict[index]?.append(drivingRecord)
            return dict
        }
        setUpContentViewForEachTab()
        setUpViewPager()
    }
}

// MARK: - RecordBreakdownDelegate
extension RecordViewController: RecordBreakdownDelegate {
    func jumpToSelectedRowDetailPage(selectedRow: DrivingRecordResponse) {
        performSegue(withIdentifier: DETAIL_PAGE_SEGUE_ID, sender: selectedRow)
    }

}
