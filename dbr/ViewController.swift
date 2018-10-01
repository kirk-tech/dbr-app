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

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleTableHeight: NSLayoutConstraint!
    @IBOutlet weak var titleTable: UITableView!
    @IBOutlet weak var verseTable: UITableView!
    @IBOutlet weak var notes: UILabel!
    
    var dbr: DBR?
    var passages = [String: String]()
    let disposeBag = DisposeBag()
    var passageHeights = [String: CGFloat]()
    
    override func viewDidLoad() {

        self.titleTable.delegate = self
        self.titleTable.dataSource = self
        self.verseTable.delegate = self
        self.verseTable.dataSource = self
        
        self.titleTable.sectionHeaderHeight = 0.0;
        
        self.verseTable.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.verseTable.estimatedSectionHeaderHeight = 60;
        self.verseTable.rowHeight = UITableViewAutomaticDimension
        
        let titleCellNib = UINib.init(nibName: "TitleCell", bundle: nil)
        self.titleTable.register(titleCellNib, forCellReuseIdentifier: "TitleCell")
        
        let verseCellNib = UINib.init(nibName: "VerseCell", bundle: nil)
        self.verseTable.register(verseCellNib, forCellReuseIdentifier: "VerseCell")
        
        let verseHeaderNib = UINib(nibName: "VerseHeader", bundle: nil)
        self.verseTable.register(verseHeaderNib, forHeaderFooterViewReuseIdentifier: "VerseHeader")
        
        CompassService.todaysReading().subscribe(
            onNext: { dbr in
                guard let br = dbr else { return /* TODO: Handle failed request for todays readings */ }
                self.dbr = br
                self.updatePastorsNotes()
                self.titleTable.reloadData()
                ESVService.getPassages(br.verses).subscribe(onNext: { passages in
                    guard let pass = passages else { return /* TODO: Handle failed request for passages */ }
                    self.passages = pass
                    self.verseTable.reloadData()
                }).disposed(by: self.disposeBag)
                
        }).disposed(by: self.disposeBag)
        
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.titleTableHeight?.constant = self.titleTable.contentSize.height
    }
    
    func updatePastorsNotes() -> Void {
        guard let pastorsNotes = dbr?.pastorsNotes[0] else { return }
        self.notes.text = pastorsNotes
        self.notes.setLineSpacing(3.0, multiple: 1.2)
    }
    
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
        guard let passage = self.passages[verse] else { return UITableViewCell() }
        let cell = verseTable.dequeueReusableCell(withIdentifier: "VerseCell") as! VerseCell
        
        cell.setPassage(passage)
        
        // Save the height for later use in row height
        let passageHeight = cell.getOptimalLabelHeight()
        self.passageHeights[verse] = passageHeight
        
        return cell
    }
    
    func verseTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.verseTable.dequeueReusableHeaderFooterView(withIdentifier: "VerseHeader") as! VerseHeader
        
        let verse = dbr?.verses[section]
        if let v = verse { header.setVerse(v) }
        
        return header
    }
    
}

extension ViewController:  UITableViewDataSource, UITableViewDelegate {
    
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
        return self.dbr?.verses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (tableView == self.verseTable) {
            return verseTableView(tableView, viewForHeaderInSection: section)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard tableView == self.verseTable else { return 50 }
        guard let d = dbr else { return 50 }
        let verse = d.verses[indexPath.section]
        return passageHeights[verse] ?? 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView == verseTable else { return }
        let isLastCell = indexPath.section == (self.dbr?.verses.count ?? 0) - 1
        if isLastCell {
            self.contentViewHeight.constant = self.passageHeights.values.reduce(0, +) + 1000
        }
    }
    
}
