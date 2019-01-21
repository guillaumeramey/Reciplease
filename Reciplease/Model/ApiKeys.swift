//
//  ApiKeys.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 13/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

// Wrapper for obtaining keys from keys.plist
func valueForAPIKey(_ keyname: String) -> String {
    // Get the file path for keys.plist
    let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")

    // Put the keys in a dictionary
    let plist = NSDictionary(contentsOfFile: filePath!)

    // Pull the value for the key
    let value: String = plist?.object(forKey: keyname) as! String

    return value
}
