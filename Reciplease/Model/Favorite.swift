//
//  Favorite.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 22/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation
import CoreData

class Favorite: NSManagedObject {

    static var all: [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favorites = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return favorites
    }

    static var recipes: [Recipe] {
        var recipes = [Recipe]()
        for favorite in all {
            if let id = favorite.id, let name = favorite.name, let imageSmall = favorite.imageSmall, let ingredients = favorite.ingredients, let course = favorite.course {
                let ingredientsArray = ingredients.components(separatedBy: ", ")
                let recipe = Recipe(id: id, name: name, imageSmall: imageSmall, rating: favorite.rating, ingredients: ingredientsArray, totalTimeInSeconds : favorite.totalTimeInSeconds, course: course)
                recipes.append(recipe)
            }
        }
        return recipes
    }
}
