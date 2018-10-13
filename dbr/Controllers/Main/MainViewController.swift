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
    var dbrView: UIView?
    
    var dbrViewLeadingAnchor: NSLayoutConstraint?
    var dbrViewTrailingAnchor: NSLayoutConstraint?
    var menuViewLeadingAnchor: NSLayoutConstraint?
    var settingsViewLeadingAnchor: NSLayoutConstraint?
    
    // TODO: Add to state store
    var settingsAreVisible = false
    
    // DEV
    let DISABLE_SETTINGS_SCROLL = true
    
    var settingsViewWidth: CGFloat {
        return self.view.frame.maxX - UIConstants.menuWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let dbrController = UIViewController.initWithStoryboard(DailyBibleReadingViewController.self),
            let menuBarController = UIViewController.initWithStoryboard(MenuBarViewController.self),
            let settingsController = UIViewController.initWithStoryboard(SettingsViewController.self)
        else {
            fatalError()
        }
        
        self.addChildViewController(dbrController)
        self.addChildViewController(menuBarController)
        self.addChildViewController(settingsController)
        
        // Order is important here - dbr view must get added
        // last so it sits on top of the menu
        self.view.addSubview(menuBarController.view)
        self.view.addSubview(dbrController.view)
        self.view.addSubview(settingsController.view)
        
        //
        // Place a cover over the staus bar section. This will clip our drop shadows from running into the status bar (visibly)
        //
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = .white
        view.addSubview(statusBarView)
        
        
        //
        //  Place the Menu Bar
        //
        menuBarController.view.translatesAutoresizingMaskIntoConstraints = false
        menuBarController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        menuBarController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        let menuWidthConstraint = menuBarController.view.widthAnchor.constraint(equalToConstant: UIConstants.menuWidth)
        menuWidthConstraint.priority = UILayoutPriority(999) // Makes annoying warning go away
        menuWidthConstraint.isActive = true
        self.menuViewLeadingAnchor = menuBarController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0) // UIConstants.menuWidth * -1)
        self.menuViewLeadingAnchor?.isActive = true
        
        
        //
        //  Place the DBR view
        //
        dbrView = dbrController.view
        dbrView?.translatesAutoresizingMaskIntoConstraints = false
        dbrView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        dbrView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.dbrViewLeadingAnchor = dbrView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        self.dbrViewTrailingAnchor = dbrView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        self.dbrViewLeadingAnchor?.isActive = true
        self.dbrViewTrailingAnchor?.isActive = true
        // Give the DBR view a drop shadow
        dbrView?.addDropShadow(color: .black, opacity: 0.4, offSet: CGSize(width: -3, height: 0), radius: 4)


        //
        // Place the Settings view
        //
        let settingsView = settingsController.view
        settingsView?.translatesAutoresizingMaskIntoConstraints = false
        settingsView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        settingsView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        settingsView?.widthAnchor.constraint(equalToConstant: self.view.frame.maxX - UIConstants.menuWidth).isActive = true
        self.settingsViewLeadingAnchor = settingsView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        self.settingsViewLeadingAnchor?.constant = self.settingsViewWidth * -1
        self.settingsViewLeadingAnchor?.isActive = true
        
        settingsController.view.backgroundColor = .green
        
        
        //
        // Setup listeners for events
        //
        AppDelegate.global.store?.menuIsVisible.change.subscribe { menuIsVisible in
            if menuIsVisible.element! { self.showMenu() }
            else { self.hideMenu() }
        }.disposed(by: disposeBag)
        
        if !DISABLE_SETTINGS_SCROLL {
            
            let panGesture = menuBarController.view.rx.panGesture()
            
            panGesture.when(.ended)
                .asTranslation()
                .subscribe(onNext: self.onMenuBarPanEnd)
                .disposed(by: self.disposeBag)
            
            panGesture.when(.changed)
                .asTranslation()
                .map { self.settingsAreVisible ? (UIScreen.main.bounds.maxX - UIConstants.menuWidth) + $0.translation.x : $0.translation.x }
                // .distinctUntilChanged { $0.velocity.x } // TODO: Not working :(
                // .buffer(timeSpan: 0.1, count: 100, scheduler: MainScheduler.instance)
                // .map { move in move.map { $0.translation.x }.reduce(0, +) }
                .subscribe(onNext: self.onMenuBarPanChange)
                .disposed(by: self.disposeBag)
        }
        
        let cornerRadius: CGFloat = 10
        let cornerImage = UIImage(named: "blacked_out_corner.png")!
        
        let topLeftCorner = UIImageView(image: cornerImage)
        self.view.addSubview(topLeftCorner)
        topLeftCorner.translatesAutoresizingMaskIntoConstraints = false
        topLeftCorner.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topLeftCorner.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topLeftCorner.widthAnchor.constraint(equalToConstant: cornerRadius).isActive = true
        topLeftCorner.heightAnchor.constraint(equalToConstant: cornerRadius).isActive = true
        
        let topRightCorner = UIImageView(image: cornerImage)
        topRightCorner.transform = CGAffineTransform(rotationDegrees: 90)
        self.view.addSubview(topRightCorner)
        topRightCorner.translatesAutoresizingMaskIntoConstraints = false
        topRightCorner.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        topRightCorner.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topRightCorner.widthAnchor.constraint(equalToConstant: cornerRadius).isActive = true
        topRightCorner.heightAnchor.constraint(equalToConstant: cornerRadius).isActive = true
        
        let bottomLeftCorner = UIImageView(image: cornerImage)
        bottomLeftCorner.transform = CGAffineTransform(rotationDegrees: -90)
        self.view.addSubview(bottomLeftCorner)
        bottomLeftCorner.translatesAutoresizingMaskIntoConstraints = false
        bottomLeftCorner.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomLeftCorner.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomLeftCorner.widthAnchor.constraint(equalToConstant: cornerRadius).isActive = true
        bottomLeftCorner.heightAnchor.constraint(equalToConstant: cornerRadius).isActive = true
        
        let bottomRightCorner = UIImageView(image: cornerImage)
        bottomRightCorner.transform = CGAffineTransform(rotationDegrees: -180)
        self.view.addSubview(bottomRightCorner)
        bottomRightCorner.translatesAutoresizingMaskIntoConstraints = false
        bottomRightCorner.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomRightCorner.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomRightCorner.widthAnchor.constraint(equalToConstant: cornerRadius).isActive = true
        bottomRightCorner.heightAnchor.constraint(equalToConstant: cornerRadius).isActive = true
        
        
    }
    
    func showMenu() {
        
        self.dbrViewLeadingAnchor?.constant = UIConstants.menuWidth
        self.dbrViewTrailingAnchor?.constant = UIConstants.menuWidth
        // self.menuViewLeadingAnchor?.constant = 0
        
        animateMenuMove()
        
        self.addSwipeableViewOverDBR()
        
    }
    
    func addSwipeableViewOverDBR() -> Void {
        guard self.view.viewWithTag(2932) == nil else { return }
        
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
    
    func removeSwipeableViewFromDBR() -> Void {
        if let coverView = self.view.viewWithTag(2932) {
            coverView.removeFromSuperview()
        }
    }
    
    @objc func handleCloseSwipe(gestureRecognizer: UIGestureRecognizer) {
        AppDelegate.global.store?.menuIsVisible.value = false
    }
    
    func hideMenu() {
        self.removeSwipeableViewFromDBR()
        // Move the dbr view over
        self.dbrViewLeadingAnchor?.constant = 0
        self.dbrViewTrailingAnchor?.constant = 0
        // self.menuViewLeadingAnchor?.constant = UIConstants.menuWidth * -1
        
        animateMenuMove()
    }
    
    func animateMenuMove() {
        UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: {
            self.view.layoutIfNeeded()
        }).startAnimation()
    }
    
    func onMenuBarPanChange(_ x: CGFloat) -> Void {
        let newMenuX = self.view.frame.minX + x
        guard newMenuX != 0.0 else { return }
        self.slideView(toX: newMenuX)
    }
    
    func onMenuBarPanEnd(_ translation: CGPoint, _ velocity: CGPoint) -> Void {
        // Decide if the view is currenly closer to
        // open or close and then snap it to that side
        let leadingMenuX = self.menuViewLeadingAnchor?.constant ?? 0
        let currentMenuXPosition = leadingMenuX + (UIConstants.menuWidth / 2)
        let halfWayMark = UIScreen.main.bounds.midX
        
        if currentMenuXPosition >= halfWayMark {
            self.slideMenuToSetting()
        } else {
            self.slideMenuToDBR()
        }
    }
    
    func slideMenuToSetting() -> Void {

        self.removeSwipeableViewFromDBR()
        
        // Move the menu bar
        self.menuViewLeadingAnchor?.constant = UIScreen.main.bounds.maxX - UIConstants.menuWidth
        
        // Move the dbr view
        self.dbrViewLeadingAnchor?.constant = UIScreen.main.bounds.maxX
        self.dbrViewTrailingAnchor?.constant = UIScreen.main.bounds.maxX + (UIScreen.main.bounds.maxX - UIConstants.menuWidth)
        
        // Move the settings
        self.settingsViewLeadingAnchor?.constant = 0
        
        self.settingsAreVisible = true
        
        self.animateMenuMove()
    }
    
    func slideMenuToDBR() -> Void {

        self.addSwipeableViewOverDBR()
        
        // Move the menu bar
        self.menuViewLeadingAnchor?.constant = 0
        
        // Move the dbr view
        self.dbrViewLeadingAnchor?.constant = UIConstants.menuWidth
        self.dbrViewTrailingAnchor?.constant = UIConstants.menuWidth
        
        // Move the settings
        self.settingsViewLeadingAnchor?.constant = self.settingsViewWidth * -1
        
        self.settingsAreVisible = false
        
        self.animateMenuMove()
    }
    
    func slideView(toX x: CGFloat) -> Void {
        
        // Move the menu bar
        self.menuViewLeadingAnchor?.constant = x
        
        // Move the dbr view
        self.dbrViewLeadingAnchor?.constant = UIConstants.menuWidth + x
        self.dbrViewTrailingAnchor?.constant = UIConstants.menuWidth + x
        
        // Move the settings
        self.settingsViewLeadingAnchor?.constant = (self.settingsViewWidth * -1) + x
    }
    
}
