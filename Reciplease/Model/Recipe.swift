//
//  Recipe.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 20/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation
import CoreData

class Recipe {
    let id: String
    let recipeName: String
    let rating: Int16
    let totalTimeInSeconds: Int32?
    let ingredients: String
    let imageSmall: URL?
    let course: String

    // Recipe details
    var imageBig: URL?
    var ingredientLines: [String]?
    var totalTime: String?
    var numberOfServings: Int?
    var recipeURL: URL?

    init(id: String, name: String, imageSmall: URL?, rating: Int16, ingredients: String, totalTimeInSeconds: Int32, course: String) {
        self.id = id
        self.recipeName = name
        self.imageSmall = imageSmall
        self.rating = rating
        self.ingredients = ingredients
        self.totalTimeInSeconds = totalTimeInSeconds
        self.course = course
    }

    // MARK: - CORE DATA ACTIONS
    func addToFavorites(coreDataStack: CoreDataStack) -> Bool {
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: coreDataStack.viewContext) as! Favorite
        favorite.id = id
        favorite.name = recipeName
        favorite.rating = rating
        favorite.imageSmall = imageSmall
        favorite.ingredients = ingredients
        favorite.totalTimeInSeconds = totalTimeInSeconds ?? 0
        favorite.course = course
        return coreDataStack.saveContext()
    }

    func deleteFromFavorites(coreDataStack: CoreDataStack) -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)

        guard let recipes = try? coreDataStack.viewContext.fetch(request) else {
            return false
        }

        coreDataStack.viewContext.delete(recipes[0])
        return coreDataStack.saveContext()
    }
}
