//
//  UIPanGestureRecognizer.swift
//  dbr
//
//  Created by Ray Krow on 10/10/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit


extension UIPanGestureRecognizer {
    
    var detectionLimit: CGFloat {
        return 50
    }
    
    func isLeft(view: UIView) -> Bool {
        let vel: CGPoint = velocity(in: view)
        return vel.x < -detectionLimit
    }
    
    func getXAxisChange(_ view: UIView) -> CGFloat {
        let vel: CGPoint = velocity(in: view)
        return vel.x
    }
    
}
