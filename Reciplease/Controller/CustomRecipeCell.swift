//
//  RecipeCell.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 07/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class CustomRecipeCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet var recipeRating: [UIImageView]!
    @IBOutlet weak var recipeCookingTime: UILabel!

    // MARK: - METHODS
    func setCell(with recipe: Recipe) {
        resetCell()
        setCellDesign()

        recipeName.text = recipe.recipeName

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

        for star in recipeRating where star.tag <= recipe.rating {
            star.image = UIImage(named: "star_true")
        }

        recipeIngredients.text = recipe.ingredients
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

    private func setCellDesign() {
        recipeImage.layer.borderWidth = 2
        recipeImage.layer.cornerRadius = 20
        recipeImage.layer.borderColor = UIColor.white.cgColor
        background.layer.borderWidth = 2
        background.layer.cornerRadius = 20
        background.layer.borderColor = UIColor.white.cgColor
    }
}
