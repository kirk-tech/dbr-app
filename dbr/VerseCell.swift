//
//  VerseCell.swift
//  dbr
//
//  Created by Ray Krow on 9/29/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class VerseCell: UITableViewCell {
    
    @IBOutlet weak var passage: UILabel!
    
    let disposeBag = DisposeBag()
    
    func setPassage(_ passage: String) -> Void {
        self.passage.text = passage
        self.passage.setLineSpacing(2.0, multiple: 1.2)
    }
    
    func getOptimalLabelHeight() -> CGFloat {
        return self.passage.optimalHeight
    }
    
}
