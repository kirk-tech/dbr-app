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


class MenuBarViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var upArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        self.view.addGradient([UIConstants.primaryColor.cgColor, UIConstants.secondaryColor.cgColor])
        
        self.dateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        AppDelegate.global.store!.date.change
            .subscribe(onNext: self.updateDateUI)
            .disposed(by: disposeBag)
        
        let downTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveDateDown))
        downArrow.addGestureRecognizer(downTapGestureRecognizer)
        
        let upTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveDateUp))
        upArrow.addGestureRecognizer(upTapGestureRecognizer)
        
    }
    
    func updateDateUI(_ date: Date) {
        self.dateLabel.attributedText = self.createAttributedDate(for: date)
        if date.isBefore(Date(), by: .day) {
            upArrow.isHidden = false
        } else {
            upArrow.isHidden = true
        }
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
    
    @objc func moveDateUp() {
        AppDelegate.global.store!.date.value = AppDelegate.global.store!.date.value.addingTimeInterval(86400)
    }
    
    @objc func moveDateDown() {
        AppDelegate.global.store!.date.value = AppDelegate.global.store!.date.value.addingTimeInterval(-86400)
    }
    
}
