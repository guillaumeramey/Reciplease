//
//  Recipe.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 20/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

var favorites = [Recipe]()

class Recipe {
    var isFavorite: Bool = false
    let id: String
    let name: String
    let imageSmall: String
    let rating: Int
    let ingredients: [String]
    var imageBig: String = ""
    var ingredientLines: [String] = []
    var totalTime: String = ""
    var numberOfServings: Int = 0

    init(id: String, name: String, imageSmall: String, rating: Int, ingredients: [String]) {
        self.id = id
        self.name = name
        self.imageSmall = imageSmall
        self.rating = rating
        self.ingredients = ingredients
    }
}
