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
    
    @IBOutlet weak var scrollViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pastorsNotes: UILabel!
    @IBOutlet weak var titleTable: UITableView!
    
    var dbr: DBR?
    var passages = [String: String]()
    let disposeBag = DisposeBag()
    
    let onSwipeRight = PublishSubject<Int>()
    
    override func viewDidLoad() {

        self.titleTable.delegate = self
        self.titleTable.dataSource = self
        self.titleTable.rowHeight = 80

        CompassService.todaysReading().subscribe(
            onNext: { dbr in
                guard let br = dbr else { return /* TODO: Handle failed request for todays readings */ }
                self.dbr = br
                self.updatePastorsNotes()
                self.titleTable.reloadData()
        }).disposed(by: self.disposeBag)
        
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        // super.updateViewConstraints()
        // print("updating constraints to: \(self.titleTable.contentSize.height)")
        // self.titleTableHeightConstraint?.constant = self.titleTable.contentSize.height
    }
    
    func updatePastorsNotes() -> Void {
        guard let notes = dbr?.pastorsNotes[0] else { return }
        self.pastorsNotes.text = notes
        self.pastorsNotes.setLineSpacing(2.0, multiple: 1.5)
    }
    
    @IBAction func didSwipeLeft(_ sender: Any) {
        guard let br = dbr else { return }
        let scriptureViewController = UIViewController.initWithStoryboard(named: "Scripture") as! ScriptureViewController
        scriptureViewController.passageAddresses = br.verses
        scriptureViewController.index = 0
        navigationController?.pushViewController(scriptureViewController, animated: true)
    }
    
    @IBAction func didSwipeRight(_ sender: Any) {
        self.onSwipeRight.onNext(0)
    }
    
}

extension DailyBibleReadingViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ret = self.dbr?.verses.count ?? 0
        print("rows: \(ret)")
        return ret
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let d = dbr else { return UITableViewCell() }
        let cell = titleTable.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
        cell.titleLabel.text = d.verses[indexPath.row]
        print("make na cella")
        return cell
    }
    
}


class TitleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}

