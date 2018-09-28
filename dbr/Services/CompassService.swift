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
    
    let http: HttpServiceProtocol
    
    init() {
        http = HttpService(api: "https://1qium182f6.execute-api.us-west-1.amazonaws.com/default")
    }
    
    func todaysReading() -> Observable<DBR?> {
        return self.http.get("/dbr-todays-reading")
            .map(into: DBR.self)
    }
    
}
