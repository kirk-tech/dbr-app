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
    static func initWithStoryboard<T: UIViewController>(named name: String) -> T? {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "\(name)ViewController") as? T
    }
}
