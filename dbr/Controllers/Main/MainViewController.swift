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
    
    let disposeBag = DisposeBag()
    var dbrView: UIView?
    
    var dbrViewLeadingAnchor: NSLayoutConstraint?
    var dbrViewTrailingAnchor: NSLayoutConstraint?
    var menuViewLeadingAnchor: NSLayoutConstraint?
    
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
        menuBarController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        menuBarController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        let menuWidthConstraint = menuBarController.view.widthAnchor.constraint(equalToConstant: UIConstants.menuWidth)
        menuWidthConstraint.priority = UILayoutPriority(999) // Makes annoying warning go away
        menuWidthConstraint.isActive = true
        self.menuViewLeadingAnchor = menuBarController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIConstants.menuWidth * -1)
        self.menuViewLeadingAnchor?.isActive = true
        
        dbrView = dbrController.view
        dbrView?.translatesAutoresizingMaskIntoConstraints = false
        dbrView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        dbrView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.dbrViewLeadingAnchor = dbrView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        self.dbrViewTrailingAnchor = dbrView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        self.dbrViewLeadingAnchor?.isActive = true
        self.dbrViewTrailingAnchor?.isActive = true
        
        Store.shared.menuIsVisible.change.subscribe { menuIsVisible in
            if menuIsVisible.element! { self.showMenu() }
            else { self.hideMenu() }
        }.disposed(by: disposeBag)
        
    }
    
    func showMenu() {
        
        guard !Store.shared.menuIsVisible.value else { return }
        
        self.dbrViewLeadingAnchor?.constant = UIConstants.menuWidth
        self.dbrViewTrailingAnchor?.constant = UIConstants.menuWidth
        self.menuViewLeadingAnchor?.constant = 0
        
        animateMenuMove()
        
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
        coverView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIConstants.menuWidth).isActive = true
        
        // Add a swipe gesture recognizer to the cover view
        // so we know when user trys to close view
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleCloseSwipe(gestureRecognizer:)))
        gestureRecognizer.direction = .left
        gestureRecognizer.delegate = self
        coverView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func handleCloseSwipe(gestureRecognizer: UIGestureRecognizer) {
        Store.shared.menuIsVisible.value = false
    }
    
    func hideMenu() {
        guard Store.shared.menuIsVisible.value else { return }
        if let coverView = self.view.viewWithTag(2932) {
            coverView.removeFromSuperview()
        }
        // Move the dbr view over
        self.dbrViewLeadingAnchor?.constant = 0
        self.dbrViewTrailingAnchor?.constant = 0
        self.menuViewLeadingAnchor?.constant = UIConstants.menuWidth * -1
        
        animateMenuMove()
        
    }
    
    func animateMenuMove() {
        //        UIView.animate(withDuration: 0.3) {
        //            self.dbrView?.layoutIfNeeded()
        //        }
        //        UIView.animate(withDuration: 1, animations: {
        //            self.dbrView?.layoutIfNeeded()
        //        }, completion: { _ in
        //            print("done animating open")
        //        })
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear, animations: {
            self.view.layoutIfNeeded()
        })
        animator.startAnimation()
    }
    
}
