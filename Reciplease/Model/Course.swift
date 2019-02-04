//
//  Course.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 24/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class Course {
    let name: String
    let color: UIColor
    var isSelected: Bool

    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
        isSelected = false
    }
}
