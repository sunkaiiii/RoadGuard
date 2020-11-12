//
//  RecordViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/30.
//

import UIKit


class RecordViewController: UIViewController, WormTabStripDelegate{

    let DETAIL_PAGE_SEGUE_ID = "recordDetailSegue"

    @IBOutlet weak var viewPager: WormTabStrip!
    
    // MARK: - Top Scroll Tab Bar Related Fields
    var tabContentViews:[UIViewController] = []
    //这里需要根据传入的record数据，替换下这个数组
    //需要传入带月份信息的 record对象
    var montlyRecords : [String]  = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

    // MARK: - Top Scroll Tab Bar Related functions
    func setUpContentViewForEachTab(){
        for _ in 1...montlyRecords.count {
            let vc = RecordBreakdownViewController()
            vc.delegateParent = self
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
        viewPager.currentTabIndex = 0
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
        setUpContentViewForEachTab()
        setUpViewPager()
        // Do any additional setup after loading the view.
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DETAIL_PAGE_SEGUE_ID {
            if let des = segue.destination as? RecordDetailViewController{
                //需要改传值类型
                des.selectedRecord = sender as? String
            }

        }
    }
}

// MARK: - RecordBreakdownDelegate
extension RecordViewController: RecordBreakdownDelegate {
    //需要改传值类型
    func jumpToSelectedRowDetailPage(selectedRow: String) {
        performSegue(withIdentifier: DETAIL_PAGE_SEGUE_ID, sender: selectedRow)
    }
}
