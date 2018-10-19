//
//  MainViewController.swift
//  dbr
//
//  Created by Ray Krow on 10/1/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ScriptureViewController: UIViewController {
 
    @IBOutlet weak var passageTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleAddress: UILabel!
    @IBOutlet weak var passageTable: UITableView!
    
    let disposeBag = DisposeBag()
    var passages = [String]()
    
    override func viewDidLoad() {
        
        self.passageTable.delegate = self
        self.passageTable.dataSource = self
        self.passageTable.sectionHeaderHeight = 0
        self.passageTable.sectionFooterHeight = 0
        
        AppDelegate.global.store?.passage.change
            .subscribe(onNext: self.displayPassage)
            .disposed(by: self.disposeBag)
        
    }
    
    func displayPassage(_ passage: String?) {
        guard let passageAddress = passage else { return }
        self.titleAddress.text = passageAddress
        ScriptureService.getPassage(passageAddress).subscribe(onNext: { scripture in
            
            // TODO: Handle failure to get pasage text
            guard let text = scripture else { return }
            
            self.passages = ScriptureParser.splitScriptureIntoChapters(text)
            self.passageTable.reloadData()
            
            // HACK: Table not laying out correctly
            // so here we force it to layout right away
            // and then forcefully set the height
            self.passageTable.layoutIfNeeded()
            self.passageTableHeightConstraint.constant = self.passageTable.contentSize.height
            
        }).disposed(by: disposeBag)
    }
    
}

extension ScriptureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.passages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.passageTable.dequeueReusableCell(withIdentifier: "ScriptureCell") as! ScriptureCell
        let scripture = self.passages[indexPath.row]
        
        let builder = ScriptureParser(for: scripture)
        builder.applyAttributeToScripture(.paragraphStyle, value: NSMutableParagraphStyle(lineSpacing: 1.0, multiple: 1.3))
        builder.applyAttributeToVerseNumbers(.baselineOffset, value: 8)
        builder.applyAttributeToVerseNumbers(.font, value: UIFont(name: "OpenSans-Regular", size: 9)!)
        builder.applyAttributeToVerseNumbers(.foregroundColor, value: UIColor.lightGray)
        builder.applyAttributeToSectionTitles(.font, value: UIFont(name: "OpenSans-SemiBold", size: 15)!)
        
        cell.scriptureLabel.attributedText = builder.attributedScripture
        
        return cell
    }
    
}

class ScriptureCell: UITableViewCell {
    @IBOutlet weak var scriptureLabel: UILabel!
}
