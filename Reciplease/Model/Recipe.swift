//
//  Recipe.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 20/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

struct Recipe: Decodable {
    let id: String
    let recipeName: String
    let rating: Int
    let totalTimeInSeconds: Int
    let ingredients: [String]
    private let smallImageUrls: [String]
    var imageSmall: String {
        return smallImageUrls[0]
    }

    // Recipe details
    var imageBig: String?
    var ingredientLines: [String]?
    var totalTime: String?
    var numberOfServings: Int?
    var recipeURL: String?

    init(id: String, name: String, smallImageUrls: [String], rating: Int, ingredients: [String], totalTimeInSeconds: Int) {
        self.id = id
        self.recipeName = name
        self.smallImageUrls = smallImageUrls
        self.rating = rating
        self.ingredients = ingredients
        self.totalTimeInSeconds = totalTimeInSeconds
    }
}
