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
        return HttpService.get("\(CompassService.api)/dbr-todays-reading")
            .map(into: DBR.self)
    }
    
}
