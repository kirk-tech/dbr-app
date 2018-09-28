//
//  Error.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation

struct DBRError: Error {
    let message: String
    let apiError: String?
    init(data: Data?, message: String) {
        self.message = message
        if let d = data {
            self.apiError = String(data: d, encoding: .utf8)
        } else {
            self.apiError = nil
        }
    }
}

struct GenericDecodingError: Error {
    
}
