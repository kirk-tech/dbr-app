//
//  Observable+cache.swift
//  dbr
//
//  Created by Ray Krow on 10/3/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where E: Codable {
    func cache(usingKey key: String) -> Observable<Element> {
        return self.map { result in
            print("######")
            print("RESULT")
            print("######")
            print(result)
            print("")
            AppDelegate.global.cache?.persist(result, key: key)
            
            return result
        }
    }
}

