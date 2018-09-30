//
//  TitleCell.swift
//  dbr
//
//  Created by Ray Krow on 9/29/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

class TitleCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func setTitle(_ title: String) -> Void {
        self.label.text = title
    }
    
}
