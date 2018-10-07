//
//  Array+prepend.swift
//  dbr
//
//  Created by Ray Krow on 10/6/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation

extension Array where Element: Any {
    mutating func prepend(_ element: Element) {
        self.insert(element, at: 0)
    }
}

extension Array where Element: StringProtocol {
    func shake() -> Array<Element> {
        return self.filter { !$0.isEmpty }
    }
}

