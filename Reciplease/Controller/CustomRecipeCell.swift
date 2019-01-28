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
    @IBOutlet weak var recipeCookingTime: UILabel!

    func set(recipe: Recipe) {
        recipeImage.layer.borderWidth = 4
        recipeImage.layer.cornerRadius = 10

        recipeName.text = recipe.recipeName

        if let course = courses.first(where: {$0.name == recipe.course}) {
            recipeImage.layer.borderColor = course.color.cgColor
            recipeName.textColor = course.color
        }

        if let url = URL(string: recipe.imageSmall) {
            SearchService().getImage(from: url, completion: { (image) in
                if let image = image {
                    self.recipeImage.image = image
                } else {
                    self.recipeImage.image = UIImage(named: "noImage")
                }
            })
        } else {
            self.recipeImage.image = UIImage(named: "noImage")
        }

        for star in recipeRating {
            if star.tag <= recipe.rating {
                star.image = UIImage(named: "star_true")
            } else {
                star.image = UIImage(named: "star_false")
            }
        }

        recipeIngredients.text = recipe.ingredients.joined(separator: ", ")
        recipeCookingTime.text = recipe.totalTimeInSeconds.convertToTimeString()
    }
}
