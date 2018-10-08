//
//  NSMutableParagraphStyle+init.swift
//  dbr
//
//  Created by Ray Krow on 10/8/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableParagraphStyle {
    convenience init(lineSpacing: CGFloat, multiple: CGFloat) {
        self.init()
        self.lineSpacing = lineSpacing
        self.lineHeightMultiple = multiple
        self.alignment = .justified
    }
}
