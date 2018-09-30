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
    
    static func getPassage(_ passage: String) -> Observable<[String]?> {
        return HttpService.get("https://api.esv.org/v3/passage/text", parameters: ["q": passage], headers: ["Authorization": "Token \(ESVService.token)"])
            .map(into: ESVPassageResponse.self)
            .map { response in response?.passages }
    }
    
    // TODO: func getAudio...
    
}
