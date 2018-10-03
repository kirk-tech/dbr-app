//
//  MainViewController.swift
//  dbr
//
//  Created by Ray Krow on 10/2/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var menuIsVisible = false
    let disposeBag = DisposeBag()
    var dbrView: UIView?
    
    var dbrViewLeadingAnchor: NSLayoutConstraint?
    var dbrViewTrailingAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbrController = UIViewController.initWithStoryboard(named: "DailyBibleReading") as! DailyBibleReadingViewController
        let menuBarController = UIViewController.initWithStoryboard(named: "MenuBar") as! MenuBarViewController
        
        self.addChildViewController(dbrController)
        self.addChildViewController(menuBarController)
        
        // Order is important here - dbr view must get added
        // last so it sits on top of the menu
        self.view.addSubview(menuBarController.view)
        self.view.addSubview(dbrController.view)
        
        menuBarController.view.translatesAutoresizingMaskIntoConstraints = false
        menuBarController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        menuBarController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        menuBarController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        let menuWidthConstraint = menuBarController.view.widthAnchor.constraint(equalToConstant: 130)
        menuWidthConstraint.priority = UILayoutPriority(999) // Makes annoying warning go away
        menuWidthConstraint.isActive = true
        
        dbrView = dbrController.view
        dbrView?.translatesAutoresizingMaskIntoConstraints = false
        dbrView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        dbrView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.dbrViewLeadingAnchor = dbrView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        self.dbrViewTrailingAnchor = dbrView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        self.dbrViewLeadingAnchor?.isActive = true
        self.dbrViewTrailingAnchor?.isActive = true
        
        Store.shared.shouldShowMenu.change.subscribe(onNext: { shouldShowMenu in
            if shouldShowMenu {
                self.showMenu()
            } else {
                self.hideMenu()
            }
        }).disposed(by: disposeBag)
        
    }
    
    func showMenu() {
        
        guard !self.menuIsVisible else { return }
        
        // Move the dbr view over 130
        self.dbrViewLeadingAnchor?.constant = 130
        self.dbrViewTrailingAnchor?.constant = 130
        
        // Create a view and add it over the top of
        // the area where the dbr view is now sitting
        let coverView = UIView()
        coverView.tag = 2932
        self.view.addSubview(coverView)
        
        // Position cover view over the dbr section
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        coverView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        coverView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        coverView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 130).isActive = true
        
        // Add a swipe gesture recognizer to the cover view
        // so we know when user trys to close view
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleCloseSwipe(gestureRecognizer:)))
        gestureRecognizer.direction = .left
        gestureRecognizer.delegate = self
        coverView.addGestureRecognizer(gestureRecognizer)
        
        menuIsVisible = true
        
    }
    
    @objc func handleCloseSwipe(gestureRecognizer: UIGestureRecognizer) {
        hideMenu()
    }
    
    func hideMenu() {
        guard self.menuIsVisible else { return }
        if let coverView = self.view.viewWithTag(2932) {
            coverView.removeFromSuperview()
        }
        // Move the dbr view over 130
        self.dbrViewLeadingAnchor?.constant = 0
        self.dbrViewTrailingAnchor?.constant = 0
        menuIsVisible = false
    }
    
}
