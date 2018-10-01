//
//  ViewController.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var titleTableHeight: NSLayoutConstraint!
    @IBOutlet weak var titleTable: UITableView!
    @IBOutlet weak var verseTable: UITableView!
    @IBOutlet weak var notes: UILabel!
    
    var dbr: DBR?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {

        self.titleTable.delegate = self
        self.titleTable.dataSource = self
        self.verseTable.delegate = self
        self.verseTable.dataSource = self
        
        self.titleTable.sectionHeaderHeight = 0.0;
        
        // self.titleTable.rowHeight = UITableViewAutomaticDimension
        self.verseTable.rowHeight = UITableViewAutomaticDimension
        
        let titleCellNib = UINib.init(nibName: "TitleCell", bundle: nil)
        self.titleTable.register(titleCellNib, forCellReuseIdentifier: "TitleCell")
        
        let verseCellNib = UINib.init(nibName: "VerseCell", bundle: nil)
        self.verseTable.register(verseCellNib, forCellReuseIdentifier: "VerseCell")
        
        let verseHeaderNib = UINib(nibName: "VerseHeader", bundle: nil)
        self.verseTable.register(verseHeaderNib, forHeaderFooterViewReuseIdentifier: "VerseHeader")
        
        CompassService.todaysReading().subscribe(
            onNext: { dbr in
                self.dbr = dbr
                self.updatePastorsNotes()
                self.titleTable.reloadData()
                self.verseTable.reloadData()
        }).disposed(by: disposeBag)
        
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.titleTableHeight?.constant = self.titleTable.contentSize.height
    }
    
    func updatePastorsNotes() -> Void {
        guard let pastorsNotes = dbr?.pastorsNotes[0] else { return }
        
        let attributedString = NSMutableAttributedString(string: pastorsNotes)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.notes.attributedText = attributedString
    }
    
}

extension ViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func titleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let d = dbr else { return UITableViewCell() }
        let title = d.verses[indexPath.section]
        let cell = titleTable.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
    
        cell.setTitle(title)
        
        return cell
    }
    
    func verseTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let d = dbr else { return UITableViewCell() }
        let verse = d.verses[indexPath.section]
        let cell = verseTable.dequeueReusableCell(withIdentifier: "VerseCell") as! VerseCell
        
        cell.setVerse(verse)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.titleTable) {
            return titleTableView(tableView, cellForRowAt: indexPath)
        } else {
            return verseTableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let ret = self.dbr?.verses.count ?? 0
        print("Number of sections: \(ret)")
        return ret
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (tableView == self.verseTable) {
            return verseTableView(tableView, viewForHeaderInSection: section)
        }
        return nil
    }
    
    func verseTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.verseTable.dequeueReusableHeaderFooterView(withIdentifier: "VerseHeader") as! VerseHeader
        
        let verse = dbr?.verses[section]
        if let v = verse { header.setVerse(v) }
        
        return header
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
}
