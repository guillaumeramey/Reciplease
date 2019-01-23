//
//  RecipeCell.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 07/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class CustomRecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet var recipeRating: [UIImageView]!

    func set(recipe: Recipe) {
        recipeName.text = recipe.recipeName

        do {
            let data = try Data(contentsOf: URL(string: recipe.imageSmall)!)
            recipeImage.image = UIImage(data: data) ?? UIImage(named: "noImage")!
        } catch {
            recipeImage.image = UIImage(named: "noImage")!
        }

        for index in 0 ..< recipe.rating {
            recipeRating[index].image = UIImage(named: "star_true")
        }

        recipeIngredients.text = recipe.ingredients.joined(separator: ", ")
    }
}
