//
//  Date+dbrFormat.swift
//  dbr
//
//  Created by Ray Krow on 10/3/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation

extension Date {
    
    func dbrFormat() -> String {
        let formatter = DateFormatter()
        // DO NOT MESS WITH THIS!!! The compass bible church website
        // expects this exact format to get the bible reading on the
        // requested date. change at serious peril.................
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: self)
    }
    
    func longMonthFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: self)
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let daySuffix = (day % 10 == 1 && day != 11) ? "st"
            : (day % 10 == 2 && day != 12) ? "nd"
            : (day % 10 == 3 && day != 13) ? "rd"
            : "th"
        
        return "\(month) \(day)\(daySuffix)"
    }
}
