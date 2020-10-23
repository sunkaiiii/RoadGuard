//
//  BaseUIView.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 23/10/20.
//
//add xib into storyboard, references on https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%9C%A8-storyboard-%E5%8A%A0%E5%85%A5-xib-%E7%9A%84-view-e94826a7a8f3

import UIKit

open class BaseUIView:UIView{
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        addXibView()
    }
    
    func addXibView(){
//        print(self.classForCoder.class())
//        print("\(self.classForCoder.class())")
        if let speedAlertView = Bundle(for: self.classForCoder.class()).loadNibNamed("\(self.classForCoder.class())", owner: nil, options: nil)?.first as? UIView{
            self.addSubview(speedAlertView)
            speedAlertView.frame=bounds
        }
    }
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addXibView()
    }
}
