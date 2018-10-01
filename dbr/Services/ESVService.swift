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
        let params = [
            "q": passage,
            "include-passage-references": "false",
            "include-footnotes": "false"
        ]
        let headers = ["Authorization": "Token \(ESVService.token)"]
        return HttpService.get("https://api.esv.org/v3/passage/text/", parameters: params, headers: headers)
            .map(into: ESVPassageResponse.self)
            .map { response in response?.passages[0] }
    }
    
    static func getPassages(_ addresses: [String]) -> Observable<[String: String]?> {
        let params = [
            "q": addresses.joined(separator: ";"),
            "include-passage-references": "false",
            "include-footnotes": "false"
        ]
        let headers = ["Authorization": "Token \(ESVService.token)"]
        return HttpService.get("https://api.esv.org/v3/passage/text/", parameters: params, headers: headers)
            .map(into: ESVPassageResponse.self)
            .map { response in
                guard let ps = response?.passages else { return nil }
                var res = [String: String]()
                for (index, passage) in ps.enumerated() {
                    res[addresses[index]] = passage
                }
                return res
            }
    }
    
    // TODO: func getAudio...
    
}
