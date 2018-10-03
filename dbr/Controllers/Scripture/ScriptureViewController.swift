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
 
    @IBOutlet weak var titleAddress: UILabel!
    @IBOutlet weak var passageLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var address: String? {
        get {
            let index = Store.shared.scriptureIndex.value
            let verses = Store.shared.dbr.value?.verses
            return verses?[index]
        }
    }
    
    override func viewDidLoad() {
        Store.shared.scriptureIndex.value += 1
        self.titleAddress.text = address
        ESVService.getPassage(address!).subscribe(onNext: { passage in
            self.passageLabel.text = passage
            // TODO: Get this to work ---v
            // self.passageLabel.setLineSpacing(2.0, multiple: 1.5)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didSwipeRight(_ sender: Any) {
        print("deca...")
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
