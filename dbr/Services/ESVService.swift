//
//  ESVService.swift
//  dbr
//
//  Created by Ray Krow on 9/29/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import RxSwift

struct ESVService {
    
    static let token = "c8e9443e501ba6ca417f14d0407f2d7459a22a0f"
    
    static func getPassage(_ passage: String) -> Observable<String?> {
        if let data: ESVPassageResponse = AppDelegate.global.cache?.retrieve(passage) {
            return Observable.just(data.passages[0])
        }
        let params = [
            "q": passage,
            "include-passage-references": "false",
            "include-footnotes": "false"
        ]
        let headers = ["Authorization": "Token \(ESVService.token)"]
        return HttpService.get("https://api.esv.org/v3/passage/text/", parameters: params, headers: headers)
            .map(into: ESVPassageResponse.self)
            .cache(usingKey: passage)
            .map { response in response?.passages[0] }
    }
    
    // TODO: func getAudio...
    
}
