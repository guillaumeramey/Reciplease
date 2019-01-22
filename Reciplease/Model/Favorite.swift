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
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favorites = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        var recipes = [Recipe]()
        for favorite in favorites {
            if let id = favorite.id {
                let recipe = Recipe(id: id, name: favorite.name!, imageSmall: favorite.imageSmall!, rating: Int(favorite.rating), ingredients: [])
                recipes.append(recipe)
            }
        }
        return recipes
    }

    func create(from recipe: Recipe) {
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: AppDelegate.viewContext) as! Favorite
        favorite.id = recipe.id
        favorite.name = recipe.name
        favorite.rating = Int16(recipe.rating)
        favorite.imageSmall = recipe.imageSmall

        for ingredient in recipe.ingredients {
            let newIngredient = Ingredient(context: AppDelegate.viewContext)
            newIngredient.name = ingredient
            favorite.addToIngredients(newIngredient)
        }
        saveContext()
    }

    func deleteFavorite(with id: String) -> Bool {
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

class Ingredient: NSManagedObject {
    
}
