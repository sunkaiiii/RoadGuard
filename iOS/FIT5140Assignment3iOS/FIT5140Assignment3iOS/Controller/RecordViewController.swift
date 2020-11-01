//
//  RecordViewController.swift
//  FIT5140Assignment3iOS
//
//  Created by Shirley on 2020/10/30.
//

import UIKit

class RecordViewController: UIViewController, WormTabStripDelegate {




    @IBOutlet weak var viewPager: WormTabStrip!
    
    // MARK: - Top Scroll Tab Bar Related Fields
    var tabs:[UIViewController] = []
    //这里需要根据传入的record数据，替换下这个数组
    var numberOfTabs = 0
    var montlyRecords : [String]  = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

    // MARK: - Top Scroll Tab Bar Related functions
    func setUpTabs(){
        for _ in 1...numberOfTabs {
            let vc = RecordBreakdownViewController()
            tabs.append(vc)
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
        return numberOfTabs
    }

    func wtsViewOfTab(index: Int) -> UIView {
        return tabs[index].view
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

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfTabs = montlyRecords.count
        setUpTabs()
        setUpViewPager()
        // Do any additional setup after loading the view.
    }

}
