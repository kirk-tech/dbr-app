//
//  ViewController.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class DailyBibleReadingViewController: UIViewController {
    
    @IBOutlet weak var dbrScrollingWrapper: UIScrollView!
    @IBOutlet weak var titleTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pastorsNotes: UILabel!
    @IBOutlet weak var titleTable: UITableView!
    @IBOutlet weak var dbrCircleIconImage: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {

        self.titleTable.delegate = self
        self.titleTable.dataSource = self
        
        AppDelegate.global.store?.date.change.subscribe(onNext: self.loadDBR).disposed(by: disposeBag)
        AppDelegate.global.store?.dbrIsLoading.change.subscribe(onNext: self.toggleLoadingView).disposed(by: disposeBag)
        
        self.dbrCircleIconImage.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.showNextScripture()
        }).disposed(by: self.disposeBag)
        
        super.viewDidLoad()
    }
    
    func toggleLoadingView(_ isLoading: Bool) -> Void {
        let isHidden = isLoading
        self.dbrScrollingWrapper.isHidden = isHidden
    }
    
    func updatePastorsNotes() -> Void {
        guard let notes = AppDelegate.global.store?.dbr.value?.pastorsNotes[0] else { return }
        self.pastorsNotes.text = notes
        self.pastorsNotes.setLineSpacing(2.0, multiple: 1.5)
    }
    
    func loadDBR(_ date: Date) -> Void {
        CompassService.reading(forDate: date)
            .retry(3)
            .subscribe(onNext: self.updateViewWithNewDBR)
            .disposed(by: self.disposeBag)
    }
    
    func updateViewWithNewDBR(_ dbr: DBR?) {
        guard dbr != nil else {
            return
        }
        AppDelegate.global.store?.dbr.value = dbr
        self.updatePastorsNotes()
        self.titleTable.reloadData()
    }
    
    @IBAction func didSwipeLeft(_ sender: Any) {
        self.showNextScripture()
    }
    
    func showNextScripture() -> Void {
        guard let scriptureViewController = UIViewController.initWithStoryboard(ScriptureViewController.self) else {
            return
        }
        navigationController?.pushViewController(scriptureViewController, animated: true)
    }
    
    @IBAction func didSwipeRight(_ sender: Any) {
        AppDelegate.global.store?.menuIsVisible.value = true
    }
    
}

extension DailyBibleReadingViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.global.store?.dbr.value?.verses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let d = AppDelegate.global.store?.dbr.value else { return UITableViewCell() }
        let cell = titleTable.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
        cell.titleLabel.text = d.verses[indexPath.row]
        return cell
    }
    
}


class TitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

