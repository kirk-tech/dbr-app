//
//  MenuBar.swift
//  dbr
//
//  Created by Ray Krow on 10/2/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxGesture


class MenuBarViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    // @IBOutlet weak var upArrow: UIImageView!
    // @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var downArrow: UIView!
    @IBOutlet weak var upArrow: UIView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        self.view.addGradient([UIConstants.primaryColor.cgColor, UIConstants.secondaryColor.cgColor])
        
        self.dateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        AppDelegate.global.store!.date.change
            .subscribe(onNext: self.updateDateUI)
            .disposed(by: disposeBag)
        
        let upSwipe = self.view.rx.swipeGesture(.up)
        let downSwipe = self.view.rx.swipeGesture(.down)
        let upTap = self.upArrow.rx.tapGesture()
        let downTap = self.downArrow.rx.tapGesture()
        
        upSwipe.subscribe(onNext: { _ in
            self.moveDateBack()
        }).disposed(by: self.disposeBag)
    
        downSwipe.subscribe(onNext: { _ in
            self.moveDateForward()
        }).disposed(by: self.disposeBag)
        
        upTap.subscribe(onNext: { _ in
            self.moveDateForward()
        }).disposed(by: self.disposeBag)
        
        downTap.subscribe(onNext: { _ in
            self.moveDateBack()
        }).disposed(by: self.disposeBag)
        
    }
    
    func canMoveDateForward() -> Bool {
        return AppDelegate.global.store!.date.value.isBefore(Date(), by: .day)
    }
    
    func canMoveDateBack() -> Bool {
        let oneMonth: Double = 86400 * 30
        return AppDelegate.global.store!.date.value.isAfter(Date().addingTimeInterval(oneMonth * -1.0), by: .day)
    }
    
    func updateDateUI(_ date: Date) {
        self.dateLabel.attributedText = self.createAttributedDate(for: date)
        upArrow.isHidden = !canMoveDateForward()
        downArrow.isHidden = !canMoveDateBack()
    }
    
    func createAttributedDate(for date: Date) -> NSAttributedString {
        let dateString = date.longMonthFormat()
        let attrString = NSMutableAttributedString(string: dateString)
        
        let daySuffixRange = NSRange(dateString.index(dateString.endIndex, offsetBy: -2)..<dateString.endIndex, in: dateString)
        let fullRange = NSRange(dateString.startIndex..<dateString.endIndex, in: dateString)
        
        attrString.addAttribute(.font, value: UIFont(name: "HeadlandOne-Regular", size: 27)!, range: fullRange)
        attrString.addAttribute(.font, value: UIFont(name: "HeadlandOne-Regular", size: 18)!, range: daySuffixRange)
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
