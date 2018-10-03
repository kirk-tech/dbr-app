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
    
    var date = Date()
    var dateChanged = PublishSubject<Date>()
    
    override func viewDidLoad() {
        self.dateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        self.updateDateLabel()
        
        let downTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveDateDown))
        downArrow.addGestureRecognizer(downTapGestureRecognizer)
        
        let upTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveDateUp))
        upArrow.addGestureRecognizer(upTapGestureRecognizer)
        
    }
    
    func updateDateLabel() {
        self.dateLabel.text = date.longMonthFormat()
    }
    
    @objc func moveDateUp() {
        print("move up")
        self.date.addTimeInterval(86400)
        self.dateChanged.onNext(self.date)
        self.updateDateLabel()
    }
    
    @objc func moveDateDown() {
        print("move down")
        self.date.addTimeInterval(-86400)
        self.dateChanged.onNext(self.date)
        self.updateDateLabel()
    }
    
}
