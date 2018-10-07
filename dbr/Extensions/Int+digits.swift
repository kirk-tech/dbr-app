//
//  Int+digits.swift
//  dbr
//
//  Created by Ray Krow on 10/6/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation

extension Int {
    var digitCount: Int {
        return NSString(string: "\(self)").length
    }
}
