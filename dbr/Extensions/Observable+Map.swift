//
//  Observable+Map.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol Mapable {
    func body() -> Any?
}

extension Result: Mapable {
    public func body() -> Any? {
        return self.value
    }
}

extension Observable where E: Mapable {
    func map<T: Codable>(into t: T.Type) -> Observable<T?> {
        return self.map { result -> T? in try? t.init(from: result.body()) }
    }
}
