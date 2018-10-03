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
            let index = Store.shared.scriptureIndex.value
            let verses = Store.shared.dbr.value?.verses
            return verses?[index]
        }
    }
    
    override func viewDidLoad() {
        
        self.passageTable.delegate = self
        self.passageTable.dataSource = self
        
        Store.shared.scriptureIndex.value += 1
        self.titleAddress.text = address
        ESVService.getPassage(address!).subscribe(onNext: { passage in
            guard let psg = passage else {
                // TODO: Handle failure to get pasage text
                return
            }
            self.updateViewWithNewPassage(psg)
        }).disposed(by: disposeBag)
    }
    
    func updateViewWithNewPassage(_ passage: String) {
        print("Count: \(passage.count)")
        self.passages = passage.components(separatedBy: "\n\n")
        self.passageTable.reloadData()
        print("contentSize.height: \(self.passageTable.contentSize.height)")
        // self.passageTableHeightConstraint.constant = self.passageTable.contentSize.height
    }
    
    @IBAction func didSwipeRight(_ sender: Any) {
        AppDelegate.global.store?.scriptureIndex.value -= 1
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSwipeLeft(_ sender: Any) {
        let canMoveToAnotherScripture: Bool = {
            let index = Store.shared.scriptureIndex.value
            let verseCount = Store.shared.dbr.value!.verses.count
            return (index + 1) < verseCount
        }()
        guard canMoveToAnotherScripture else { return }
        let scriptureViewController = UIViewController.initWithStoryboard(named: "Scripture") as! ScriptureViewController
        navigationController?.pushViewController(scriptureViewController, animated: true)
    }
    
}

extension ScriptureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("#### TABLE #####")
        print("Table count: \(self.passages.count)")
        for psg in self.passages {
            print(psg.count)
        }
        print("################")
        
        return self.passages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("making cell")
        let cell = self.passageTable.dequeueReusableCell(withIdentifier: "ScriptureCell") as! ScriptureCell
        cell.scriptureLabel.text = self.passages[indexPath.row]
        cell.scriptureLabel.setLineSpacing(2.0, multiple: 1.5)
        return cell
    }
    
}

class ScriptureCell: UITableViewCell {
    
    @IBOutlet weak var scriptureLabel: UILabel!
    
}
