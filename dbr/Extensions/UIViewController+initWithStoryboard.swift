//
//  UIViewController.swift
//  dbr
//
//  Created by Ray Krow on 10/2/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func initWithStoryboard<T: UIViewController>(_ controllerType: T.Type) -> T? {
        let className = String(describing: controllerType)
        let storyboardName = className.replacingOccurrences(of: "ViewController", with: "")
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: className) as? T
    }
}
