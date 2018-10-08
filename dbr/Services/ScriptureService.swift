//
//  ESVService.swift
//  dbr
//
//  Created by Ray Krow on 9/29/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import RxSwift

struct ScriptureService {
    
    static let api = "https://27a1jognpc.execute-api.us-west-2.amazonaws.com/default"
    
    static func getPassage(_ passage: String) -> Observable<String?> {
        let params = [
            "passage": passage
        ]
        return HttpService.get("\(ScriptureService.api)/dbr-scriptures", parameters: params)
            .map(into: ScriptureResponse.self)
            .cache(usingKey: passage)
            .map { response in response?.passages[0] }
    }

}
