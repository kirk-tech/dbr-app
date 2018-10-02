//
//  UILabel+lineSpacing.swift
//  dbr
//
//  Created by Ray Krow on 9/30/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setLineSpacing(_ lineSpacing: CGFloat, multiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = multiple
        paragraphStyle.alignment = .justified
        
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
