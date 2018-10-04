//
//  Observable+setDoneLoading.swift
//  dbr
//
//  Created by Ray Krow on 10/4/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where E: Any {
    func setDoneLoading() -> Observable<Element> {
        return self.map { result in
            AppDelegate.global.store?.dbrIsLoading.value = false
            return result
        }
    }
}

