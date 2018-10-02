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
    var passageAddresses = [String]()
    var index: Int?
    
    var address: String? {
        get {
            return index == nil ? nil : passageAddresses[index!]
        }
    }
    
    static func storyboardInstance() -> ScriptureViewController? {
        let storyboard = UIStoryboard(name: "Scripture", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ScriptureViewController") as? ScriptureViewController
    }
    
    override func viewDidLoad() {
        self.titleAddress.text = address
        ESVService.getPassage(address!).subscribe(onNext: { passage in
            self.passageLabel.text = passage
            // self.passageLabel.setLineSpacing(2.0, multiple: 1.5)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didSwipeRight(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSwipeLeft(_ sender: Any) {
        guard (self.index! + 1) < self.passageAddresses.count else { return }
        let scriptureViewController = ScriptureViewController.storyboardInstance()!
        scriptureViewController.passageAddresses = passageAddresses
        scriptureViewController.index = self.index! + 1
        navigationController?.pushViewController(scriptureViewController, animated: true)
    }
    
}
