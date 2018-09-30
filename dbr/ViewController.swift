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
    
    var dbr: DBR?
    let disposeBag = DisposeBag()

    @IBOutlet weak var titleTable: UITableView!
    @IBOutlet weak var verseTable: UITableView!
    @IBOutlet weak var notes: UILabel!
    
    override func viewDidLoad() {

        self.titleTable.delegate = self
        self.titleTable.dataSource = self
        self.verseTable.delegate = self
        self.verseTable.dataSource = self
        
        CompassService.todaysReading().subscribe(
            onNext: { dbr in
                self.dbr = dbr
                self.notes.text = dbr?.pastorsNotes[0]
                self.titleTable.reloadData()
                self.verseTable.reloadData()
        }).disposed(by: disposeBag)
        
        super.viewDidLoad()
    }
    
}

extension ViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func titleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("title table: \(self.dbr?.verses.count ?? 0)")
        return self.dbr?.verses.count ?? 0
    }
    
    func titleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Creating title cell")
        guard let d = dbr else { return UITableViewCell() }
        let title = d.verses[indexPath.row]
        let cell = titleTable.dequeueReusableCell(withIdentifier: "title_rid") as! TitleCell
    
        cell.setTitle(title)
        
        return cell
    }
    
    func verseTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("title table: \(self.dbr?.verses.count ?? 0)")
        return self.dbr?.verses.count ?? 0
    }
    
    func verseTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Creating title cell")
        guard let d = dbr else { return UITableViewCell() }
        let verse = d.verses[indexPath.row]
        let cell = verseTable.dequeueReusableCell(withIdentifier: "verse_rid") as! VerseCell
        
        cell.setVerse(verse)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.titleTable) {
            return titleTableView(tableView, numberOfRowsInSection: section)
        } else {
            return verseTableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.titleTable) {
            return titleTableView(tableView, cellForRowAt: indexPath)
        } else {
            return verseTableView(tableView, cellForRowAt: indexPath)
        }
    }
    
}
