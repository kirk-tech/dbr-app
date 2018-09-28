//
//  DBR.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation

struct DBR: Codable {
    let date: String
    let verses: [String]
    let pastorsNotes: [String]
    let audioLink: String
    
    private enum CodingKeys: String, CodingKey {
        case date
        case verses
        case pastorsNotes = "pastors_notes"
        case audioLink = "audio_link"
    }
}
