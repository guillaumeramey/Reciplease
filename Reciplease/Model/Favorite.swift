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
            if let id = favorite.id, let name = favorite.name, let image = favorite.imageSmall, let ingredients = favorite.ingredients, let course = favorite.course {
                let ingredientsArray = ingredients.components(separatedBy: ", ")
                let recipe = Recipe(id: id, name: name, smallImageUrls: [image], rating: Int(favorite.rating), ingredients: ingredientsArray, totalTimeInSeconds : Int(favorite.totalTimeInSeconds), course: course)
                recipes.append(recipe)
            }
        }
        return recipes
    }

    func create(from recipe: Recipe) {
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: AppDelegate.viewContext) as! Favorite
        favorite.id = recipe.id
        favorite.name = recipe.recipeName
        favorite.rating = Int16(recipe.rating)
        favorite.imageSmall = recipe.imageSmall
        favorite.ingredients = recipe.ingredients.joined(separator: ", ")
        favorite.totalTimeInSeconds = Int16(recipe.totalTimeInSeconds ?? 0)
        favorite.course = recipe.course
        saveContext()
    }

    func delete(id: String) -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)

        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return false
        }

        AppDelegate.viewContext.delete(recipes[0])
        saveContext()

        return true
    }

    private func saveContext() {
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print(error)
        }
    }
}
