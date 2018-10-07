//
//  Date+equality.swift
//  dbr
//
//  Created by Ray Krow on 10/7/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation

extension Date {
    func isBefore(_ date: Date, by granularity: Calendar.Component) -> Bool  {
        return Calendar.current.compare(self, to: date, toGranularity: granularity).rawValue < 0
    }
}
