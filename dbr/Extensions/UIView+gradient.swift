//
//  UIView+gradient.swift
//  dbr
//
//  Created by Ray Krow on 10/12/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func addGradient(_ colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        self.layer.insertSublayer(gradient, at: 0)
    }
}
