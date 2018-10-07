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
        
        self.view.backgroundColor = UIConstants.primaryColor
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
        self.dateLabel.text = date.longMonthFormat()
        if date.isBefore(Date(), by: .day) {
            upArrow.isHidden = false
        } else {
            upArrow.isHidden = true
        }
    }
    
    @objc func moveDateUp() {
        AppDelegate.global.store!.date.value = AppDelegate.global.store!.date.value.addingTimeInterval(86400)
    }
    
    @objc func moveDateDown() {
        AppDelegate.global.store!.date.value = AppDelegate.global.store!.date.value.addingTimeInterval(-86400)
    }
    
}
