//
//  ViewController.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import UIKit
import RxSwift

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var menuDateLabel: UILabel!
    // @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var titleTable: UITableView!
    @IBOutlet weak var notes: UILabel!
    
    @IBOutlet weak var titleTableHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTrailingConstraint: NSLayoutConstraint!
    
    var dbr: DBR?
    var passages = [String: String]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        menuDateLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

        self.titleTable.delegate = self
        self.titleTable.dataSource = self
        
        self.titleTable.sectionHeaderHeight = 0.0;

        let titleCellNib = UINib.init(nibName: "TitleCell", bundle: nil)
        self.titleTable.register(titleCellNib, forCellReuseIdentifier: "TitleCell")
        
        CompassService.todaysReading().subscribe(
            onNext: { dbr in
                guard let br = dbr else { return /* TODO: Handle failed request for todays readings */ }
                self.dbr = br
                self.updatePastorsNotes()
                self.titleTable.reloadData()
                ESVService.getPassages(br.verses).subscribe(onNext: { passages in
                    guard let pass = passages else { return /* TODO: Handle failed request for passages */ }
                    self.passages = pass
                    // TODO: Handle new passages
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
        self.notes.setLineSpacing(2.0, multiple: 1.5)
    }
    
    @IBAction func didSwipeRight(_ sender: Any) {
        guard let br = dbr else { return }
        let scriptureViewController = ScriptureViewController.storyboardInstance()!
        scriptureViewController.passageAddresses = br.verses
        scriptureViewController.index = 0
        navigationController?.pushViewController(scriptureViewController, animated: true)
    }
    
    
    @IBAction func didSwipeLeft(_ sender: Any) {
        print("SWIPEY LEFTY")
        self.scrollViewLeadingConstraint.constant = 130
        self.scrollViewTrailingConstraint.constant = -130
    }
    
}

extension SummaryViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let d = dbr else { return UITableViewCell() }
        let title = d.verses[indexPath.section]
        let cell = titleTable.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
        
        cell.setTitle(title)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dbr?.verses.count ?? 0
    }
    
}
