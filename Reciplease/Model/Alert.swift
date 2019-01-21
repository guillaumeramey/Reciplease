//
//  Alert.swift
//  Reciplease
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class Alert {

    class func present(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        vc.present(alert, animated: true)
    }
}
