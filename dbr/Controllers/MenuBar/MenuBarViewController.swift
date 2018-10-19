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

protocol MenuBarResponder {
    func tapUp() -> Void
    func tapDown() -> Void
    func swipeUp() -> Void
    func swipeDown() -> Void
    var delegate: MenuBarResponderArrowDelegate { get set }
}

protocol MenuBarResponderArrowDelegate {
    func setUpArrow(hidden: Bool) -> Void
    func setDownArrow(hidden: Bool) -> Void
}

class MenuBarViewController: UIViewController {

    @IBOutlet weak var scriptureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var downArrow: UIView!
    @IBOutlet weak var upArrow: UIView!
    @IBOutlet weak var grab: UIImageView!
    
    let disposeBag = DisposeBag()
    
    var responder: MenuBarResponder?
    
    override func viewDidLoad() {
        
        self.view.addGradient([UIConstants.primaryColor.cgColor, UIConstants.secondaryColor.cgColor])
        self.grab.transform = CGAffineTransform(rotationDegrees: 90)
        
        self.dateLabel.transform = CGAffineTransform(rotationDegrees: -90)
        self.scriptureLabel.transform = CGAffineTransform(rotationDegrees: -90)
        
        let upSwipe = self.view.rx.swipeGesture(.up)
        let downSwipe = self.view.rx.swipeGesture(.down)
        let upTap = self.upArrow.rx.tapGesture()
        let downTap = self.downArrow.rx.tapGesture()
        
        upSwipe.subscribe(onNext: { _ in
            self.responder?.swipeUp()
        }).disposed(by: self.disposeBag)
    
        downSwipe.subscribe(onNext: { _ in
            self.responder?.swipeDown()
        }).disposed(by: self.disposeBag)
        
        upTap.subscribe(onNext: { _ in
            self.responder?.tapUp()
        }).disposed(by: self.disposeBag)
        
        downTap.subscribe(onNext: { _ in
            self.responder?.tapDown()
        }).disposed(by: self.disposeBag)
        
        AppDelegate.global.store?.view.change.subscribe { change in
            guard let currentView = change.element else { return }
            switch (currentView) {
            case .dbr:
                self.responder = DateMenuBarResponder(self.dateLabel, self)
                // TODO: Animate
                self.scriptureLabel.isHidden = true
                self.dateLabel.isHidden = false
                break
            case .scripture:
                self.responder = ScriptureMenuBarResponder(self.scriptureLabel, self)
                self.responder?.delegate = self
                self.scriptureLabel.isHidden = false
                self.dateLabel.isHidden = true
                break
            default:
                return
            }
        }.disposed(by: disposeBag)
        
    }
    
}

extension MenuBarViewController: MenuBarResponderArrowDelegate {
    
    func setUpArrow(hidden: Bool) {
        self.upArrow.isHidden = hidden
        print("upArrow.isHidden: \(hidden)")
    }
    
    func setDownArrow(hidden: Bool) {
        self.downArrow.isHidden = hidden
        print("downArrow.isHidden: \(hidden)")
    }
    
}
