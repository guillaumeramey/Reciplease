//
//  NavigationController.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 16/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

}

extension UINavigationController {
    func hideNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }
}
