//
//  LocalStorageService.swift
//  dbr
//
//  Created by Ray Krow on 9/28/18.
//  Copyright © 2018 Kirk. All rights reserved.
//


import Foundation
import RxSwift

struct LocalStorageService {
    
    static func get<T>(_ key: String) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
    
    static func set(key: String, to value: Any?) -> Void {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func clear(key: String) -> Void {
        LocalStorageService.set(key: key, to: nil)
    }
    
}

extension LocalStorageService {
    
    private static func getDBRId(on date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd"
        return "dbr_\(formatter.string(from: date))"
    }
    
    static func getDBR(forday date: Date) -> DBR? {
        return LocalStorageService.get(LocalStorageService.getDBRId(on: date))
    }
    
    static func saveTodaysDbr(dbr: DBR) -> Void {
        LocalStorageService.set(key: LocalStorageService.getDBRId(on: Date()), to: dbr)
    }
    
}
