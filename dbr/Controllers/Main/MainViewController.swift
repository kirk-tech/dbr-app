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
import RxCocoa
import RxGesture

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let disposeBag = DisposeBag()
    var menuViewLeadingAnchor: NSLayoutConstraint?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let dbrController = UIViewController.initWithStoryboard(DailyBibleReadingViewController.self),
            let menuBarController = UIViewController.initWithStoryboard(MenuBarViewController.self),
            let scriptureViewController = UIViewController.initWithStoryboard(ScriptureViewController.self)
        else {
            fatalError()
        }
        
        self.addChildViewController(dbrController)
        self.addChildViewController(menuBarController)
        self.addChildViewController(scriptureViewController)
        
        self.view.addSubview(menuBarController.view)
        self.view.addSubview(dbrController.view)
        self.view.addSubview(scriptureViewController.view)
        
        let leftPanelView = scriptureViewController.view!
        let rightPanelView = dbrController.view!
        let initialPanelIsRight = true
        
        
        //
        //  Place the Menu Bar
        //
        menuBarController.view.translatesAutoresizingMaskIntoConstraints = false
        menuBarController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        menuBarController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        let menuWidthConstraint = menuBarController.view.widthAnchor.constraint(equalToConstant: UIConstants.menuWidth)
        menuWidthConstraint.priority = UILayoutPriority(999) // Makes annoying warning go away
        menuWidthConstraint.isActive = true
        let initalOffset = initialPanelIsRight ? 0.0 : self.view.frame.width - UIConstants.menuWidth
        self.menuViewLeadingAnchor = menuBarController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: initalOffset)
        self.menuViewLeadingAnchor?.isActive = true
        
        
        //
        //  Place Left Panel
        //
        leftPanelView.translatesAutoresizingMaskIntoConstraints = false
        leftPanelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        leftPanelView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        leftPanelView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: UIConstants.menuWidth * -1).isActive = true
        leftPanelView.trailingAnchor.constraint(equalTo: menuBarController.view.leadingAnchor).isActive = true
        
        
        //
        // Place Right Panel
        //
        rightPanelView.translatesAutoresizingMaskIntoConstraints = false
        rightPanelView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        rightPanelView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        rightPanelView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: UIConstants.menuWidth * -1).isActive = true
        rightPanelView.leadingAnchor.constraint(equalTo: menuBarController.view.trailingAnchor).isActive = true
        
        
        menuBarController.draggable(min: 0.0, max: self.view.frame.width - UIConstants.menuWidth)
            .on(.move, slideView)
            .on(.snapToMin, slideMenuToRightPanel)
            .on(.snapToMax, slideMenuToLeftPanel)
        
        
        self.view.addCorners()
        
    }

    func slideMenuToLeftPanel(_ x: CGFloat) -> Void {
        
        // Move the menu bar
        self.menuViewLeadingAnchor?.constant = UIScreen.main.bounds.maxX - UIConstants.menuWidth
        
        AppDelegate.global.store?.view.value = .scripture
        
        UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: {
            self.view.layoutIfNeeded()
        }).startAnimation()
    }
    
    func slideMenuToRightPanel(_ x: CGFloat) -> Void {
        
        // Move the menu bar
        self.menuViewLeadingAnchor?.constant = 0
        
        AppDelegate.global.store?.view.value = .dbr
        
        UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: {
            self.view.layoutIfNeeded()
        }).startAnimation()
    }
    
    func slideView(_ x: CGFloat) -> Void {
        
        // Move the menu bar
        self.menuViewLeadingAnchor?.constant = x
    
    }
    
}
