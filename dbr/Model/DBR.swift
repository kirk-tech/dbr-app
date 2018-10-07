//
//  DBR.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation

// Daily Bible Reading
struct DBR: Codable {
    
    let verses: [String]
    let pastorsNotes: [String]
    
    private enum CodingKeys: String, CodingKey {
        case verses
        case pastorsNotes = "pastors_notes"
    }
    
}
