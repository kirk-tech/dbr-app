//
//  UIView+addDropShadow.swift
//  dbr
//
//  Created by Ray Krow on 10/13/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

/*
 * STOLEN FROM: https://stackoverflow.com/questions/39624675/add-shadow-on-uiview-using-swift-3
 */
extension UIView {
    
    func addDropShadow(scale: Bool = true) {
        addDropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 1, scale: scale)
    }
    
    func addDropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
