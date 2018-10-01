//
//  VerseHeader.swift
//  dbr
//
//  Created by Ray Krow on 9/30/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

class VerseHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var verse: UILabel!
    
    func setVerse(_ verse: String) -> Void {
        self.verse.text = verse
    }
    
}
