//
//  MenuBar.swift
//  dbr
//
//  Created by Ray Krow on 10/2/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit


class MenuBarViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var upArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    
    private let upTag = 2902
    private let downTag = 2903
    
    override func viewDidLoad() {
        self.dateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        upArrow.tag = upTag
        downArrow.tag = downTag
        
        let downTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveDateDown))
        downArrow.addGestureRecognizer(downTapGestureRecognizer)
        
        let upTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveDateUp))
        upArrow.addGestureRecognizer(upTapGestureRecognizer)
        
    }
    
    @objc func moveDateUp() {
        print("move up")
    }
    
    @objc func moveDateDown() {
        print("move down")
    }
    
}
