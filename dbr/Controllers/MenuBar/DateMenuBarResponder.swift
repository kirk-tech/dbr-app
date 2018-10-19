//
//  DateMenuBarResponder.swift
//  dbr
//
//  Created by Ray Krow on 10/18/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class DateMenuBarResponder: MenuBarResponder {
    
    let disposeBag = DisposeBag()
    let label: UILabel
    var delegate: MenuBarResponderArrowDelegate
    
    init(_ label: UILabel, _ delegate: MenuBarResponderArrowDelegate) {
        self.label = label
        self.delegate = delegate
        AppDelegate.global.store!.date.change
            .subscribe(onNext: self.updateDateUI)
            .disposed(by: self.disposeBag)
    }
    
    func tapUp() {
        self.moveDateForward()
    }
    
    func tapDown() {
        self.moveDateBack()
    }
    
    func swipeUp() {
        self.moveDateBack()
    }
    
    func swipeDown() {
        self.moveDateForward()
    }
    
}

extension DateMenuBarResponder {
    
    func canMoveDateForward() -> Bool {
        return AppDelegate.global.store!.date.value.isBefore(Date(), by: .day)
    }
    
    func canMoveDateBack() -> Bool {
        let oneMonth: Double = 86400 * 30
        return AppDelegate.global.store!.date.value.isAfter(Date().addingTimeInterval(oneMonth * -1.0), by: .day)
    }
    
    func updateDateUI(_ date: Date) {
        self.label.attributedText = self.createAttributedDate(for: date)
        self.delegate.setDownArrow(hidden: !canMoveDateBack())
        self.delegate.setUpArrow(hidden: !canMoveDateForward())
    }
    
    func createAttributedDate(for date: Date) -> NSAttributedString {
        let dateString = date.longMonthFormat()
        let attrString = NSMutableAttributedString(string: dateString)
        
        let daySuffixRange = NSRange(dateString.index(dateString.endIndex, offsetBy: -2)..<dateString.endIndex, in: dateString)
        let fullRange = NSRange(dateString.startIndex..<dateString.endIndex, in: dateString)
        
        attrString.addAttribute(.font, value: UIFont(name: "HeadlandOne-Regular", size: 24)!, range: fullRange)
        attrString.addAttribute(.font, value: UIFont(name: "HeadlandOne-Regular", size: 17)!, range: daySuffixRange)
        attrString.addAttribute(.baselineOffset, value: 8, range: daySuffixRange)
        
        return attrString
    }
    
    func moveDateForward() {
        guard canMoveDateForward() else { return }
        AppDelegate.global.store!.date.value = AppDelegate.global.store!.date.value.addingTimeInterval(86400)
    }
    
    func moveDateBack() {
        guard canMoveDateBack() else { return }
        AppDelegate.global.store!.date.value = AppDelegate.global.store!.date.value.addingTimeInterval(-86400)
    }
    
}
