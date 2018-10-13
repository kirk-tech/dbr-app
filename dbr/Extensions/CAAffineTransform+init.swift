//
//  CAAffineTransform+init.swift
//  dbr
//
//  Created by Ray Krow on 10/13/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

extension CGAffineTransform {
    init(rotationDegrees degrees: CGFloat) {
        let radians = degrees * CGFloat.pi / 180
        self.init(rotationAngle: radians)
    }
}
