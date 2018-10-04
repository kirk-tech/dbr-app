//
//  CompassService.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import RxSwift

struct CompassService {
    
    static let api = "https://1qium182f6.execute-api.us-west-1.amazonaws.com/default"
    
    static func todaysReading() -> Observable<DBR?> {
        return CompassService.reading(forDate: Date())
    }
    
    static func reading(forDate date: Date) -> Observable<DBR?> {
        let dateId = date.dbrFormat()
        let dbrCacheId = "dbr_\(dateId)".replacingOccurrences(of: " ", with: "_")
        if let data: DBR = AppDelegate.global.cache?.retrieve(dbrCacheId) {
            return Observable.just(data)
        }
        let parameters = [
            "date": dateId
        ]
        AppDelegate.global.store?.dbrIsLoading.value = true
        return HttpService.get("\(CompassService.api)/dbr-reading", parameters: parameters)
            .map(into: DBR.self)
            .cache(usingKey: dbrCacheId)
            .setDoneLoading()
    }
    
}
