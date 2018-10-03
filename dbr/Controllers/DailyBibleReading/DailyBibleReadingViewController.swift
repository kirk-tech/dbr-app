//
//  ViewController.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import UIKit
import RxSwift

class DailyBibleReadingViewController: UIViewController {
    
    @IBOutlet weak var titleTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pastorsNotes: UILabel!
    @IBOutlet weak var titleTable: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {

        self.titleTable.delegate = self
        self.titleTable.dataSource = self
        self.titleTable.rowHeight = 80
        
        AppDelegate.global.store?.date.change.subscribe(onNext: self.loadNewDbr).disposed(by: disposeBag)

        CompassService.todaysReading()
            .subscribe(onNext: self.updateViewWithNewDBR)
            .disposed(by: self.disposeBag)
        
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
//         super.updateViewConstraints()
//         self.titleTableHeightConstraint?.constant = self.titleTable.contentSize.height
    }
    
    func updatePastorsNotes() -> Void {
        guard let notes = AppDelegate.global.store?.dbr.value?.pastorsNotes[0] else { return }
        self.pastorsNotes.text = notes
        self.pastorsNotes.setLineSpacing(2.0, multiple: 1.5)
    }
    
    func loadNewDbr(_ date: Date) -> Void {
        CompassService.reading(forDate: date)
            .subscribe(onNext: self.updateViewWithNewDBR)
            .disposed(by: self.disposeBag)
    }
    
    func updateViewWithNewDBR(_ dbr: DBR?) {
        AppDelegate.global.store?.dbr.value = dbr
        self.updatePastorsNotes()
        self.titleTable.reloadData()
    }
    
    @IBAction func didSwipeLeft(_ sender: Any) {
        let scriptureViewController = UIViewController.initWithStoryboard(named: "Scripture") as! ScriptureViewController
        navigationController?.pushViewController(scriptureViewController, animated: true)
    }
    
    @IBAction func didSwipeRight(_ sender: Any) {
        Store.shared.shouldShowMenu.value = true
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

