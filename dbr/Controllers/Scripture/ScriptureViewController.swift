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
    
    var address: String? {
        get {
            let index = AppDelegate.global.store!.scriptureIndex.value
            let verses = AppDelegate.global.store!.dbr.value?.verses
            return verses?[index]
        }
    }
    
    override func viewDidLoad() {
        
        self.passageTable.delegate = self
        self.passageTable.dataSource = self
        self.passageTable.sectionHeaderHeight = 0
        self.passageTable.sectionFooterHeight = 0
        
        AppDelegate.global.store?.scriptureIndex.value += 1
        self.titleAddress.text = address
        ScriptureService.getPassage(address!).subscribe(onNext: { passage in
            guard let psg = passage else {
                // TODO: Handle failure to get pasage text
                return
            }
            self.updateViewWithNewPassage(psg)
        }).disposed(by: disposeBag)
    }
    
    func updateViewWithNewPassage(_ passage: String) {
        self.passages = ScriptureParser.splitScriptureIntoChapters(passage)
        self.passageTable.reloadData()
        
        // HACK: Table not laying out correctly
        // so here we force it to layout right away
        // and then forcefully set the height
        self.passageTable.layoutIfNeeded()
        self.passageTableHeightConstraint.constant = self.passageTable.contentSize.height
    }
    
    @IBAction func didSwipeRight(_ sender: Any) {
        AppDelegate.global.store?.scriptureIndex.value -= 1
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSwipeLeft(_ sender: Any) {
        let canMoveToAnotherScripture: Bool = {
            let index = AppDelegate.global.store!.scriptureIndex.value
            let verseCount = AppDelegate.global.store!.dbr.value!.verses.count
            return (index + 1) < verseCount
        }()
        guard
            canMoveToAnotherScripture,
            let scriptureViewController = UIViewController.initWithStoryboard(ScriptureViewController.self)
        else {
            return
        }
        navigationController?.pushViewController(scriptureViewController, animated: true)
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
