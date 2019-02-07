//
//  Recipe.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 20/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation
import CoreData

struct Recipe {
    let id: String
    let recipeName: String
    let rating: Int16
    let totalTimeInSeconds: Int32?
    let ingredients: [String]
    let imageSmall: URL?
    let course: String?

    // Recipe details
    var imageBig: URL?
    var ingredientLines: [String]?
    var totalTime: String?
    var numberOfServings: Int?
    var recipeURL: URL?

    init(id: String, name: String, imageSmall: URL, rating: Int16, ingredients: [String], totalTimeInSeconds: Int32, course: String) {
        self.id = id
        self.recipeName = name
        self.imageSmall = imageSmall
        self.rating = rating
        self.ingredients = ingredients
        self.totalTimeInSeconds = totalTimeInSeconds
        self.course = course
    }

    func addToFavorites() -> Bool {
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: AppDelegate.viewContext) as! Favorite
        favorite.id = id
        favorite.name = recipeName
        favorite.rating = rating
        favorite.imageSmall = imageSmall
        favorite.ingredients = ingredients.joined(separator: ", ")
        favorite.totalTimeInSeconds = totalTimeInSeconds ?? 0
        favorite.course = course
        return saveContext()
    }

    func deleteFromFavorites() -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)

        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return false
        }

        AppDelegate.viewContext.delete(recipes[0])
        return saveContext()
    }

    private func saveContext() -> Bool {
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print(error)
            return false
        }
        return true
    }
}
