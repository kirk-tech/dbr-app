//
//  UIView+corners.swift
//  dbr
//
//  Created by Ray Krow on 10/18/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addCorners(size: CGFloat = 10) -> Void {
        
        let cornerImage = UIImage(named: "blacked_out_corner.png")!
        
        let topLeftCorner = UIImageView(image: cornerImage)
        let topRightCorner = UIImageView(image: cornerImage)
        let bottomLeftCorner = UIImageView(image: cornerImage)
        let bottomRightCorner = UIImageView(image: cornerImage)
        
        self.addSubview(topLeftCorner)
        self.addSubview(topRightCorner)
        self.addSubview(bottomLeftCorner)
        self.addSubview(bottomRightCorner)
        
        
        topLeftCorner.translatesAutoresizingMaskIntoConstraints = false
        topLeftCorner.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLeftCorner.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLeftCorner.widthAnchor.constraint(equalToConstant: size).isActive = true
        topLeftCorner.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        
        topRightCorner.transform = CGAffineTransform(rotationDegrees: 90)
        topRightCorner.translatesAutoresizingMaskIntoConstraints = false
        topRightCorner.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topRightCorner.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topRightCorner.widthAnchor.constraint(equalToConstant: size).isActive = true
        topRightCorner.heightAnchor.constraint(equalToConstant: size).isActive = true
        

        bottomLeftCorner.transform = CGAffineTransform(rotationDegrees: -90)
        bottomLeftCorner.translatesAutoresizingMaskIntoConstraints = false
        bottomLeftCorner.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLeftCorner.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomLeftCorner.widthAnchor.constraint(equalToConstant: size).isActive = true
        bottomLeftCorner.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        
        bottomRightCorner.transform = CGAffineTransform(rotationDegrees: -180)
        bottomRightCorner.translatesAutoresizingMaskIntoConstraints = false
        bottomRightCorner.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomRightCorner.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomRightCorner.widthAnchor.constraint(equalToConstant: size).isActive = true
        bottomRightCorner.heightAnchor.constraint(equalToConstant: size).isActive = true
        
    }
    
}
