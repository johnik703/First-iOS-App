//
//  CustomNavigationController.swift
//  Companies
//
//  Created by Daniel Peach on 1/13/18.
//  Copyright © 2018 Daniel Peach. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
