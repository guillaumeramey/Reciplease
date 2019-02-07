//
//  RecipeCell.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 07/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class CustomRecipeCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet var recipeRating: [UIImageView]!
    @IBOutlet weak var recipeCookingTime: UILabel!

    func set(recipe: Recipe) {
        resetCell()

        recipeImage.layer.borderWidth = 2
        recipeImage.layer.cornerRadius = 20
        recipeImage.layer.borderColor = UIColor.white.cgColor

        recipeName.text = recipe.recipeName

        background.layer.borderWidth = 2
        background.layer.cornerRadius = 20
        background.layer.borderColor = UIColor.white.cgColor
        if let course = Constants.courses.first(where: {$0.name == recipe.course}) {
            background.backgroundColor = course.color
        }

        if let url = recipe.imageSmall {
            RequestService().getImage(from: url, completion: { (image) in
                if let image = image {
                    self.recipeImage.image = image
                }
            })
        }

        for star in recipeRating {
            if star.tag <= recipe.rating {
                star.image = UIImage(named: "star_true")
            } else {
                star.image = UIImage(named: "star_false")
            }
        }

        recipeIngredients.text = recipe.ingredients.joined(separator: ", ")
        recipeCookingTime.text = recipe.totalTimeInSeconds?.convertToTimeString()
    }

    private func resetCell() {
        background.backgroundColor = UIColor.lightGray
        recipeName.text = ""
        recipeImage.image = UIImage(named: "noImage")
        recipeIngredients.text = ""
        recipeCookingTime.text = ""
        for star in recipeRating {
            star.image = UIImage(named: "star_false")
        }
    }
}
