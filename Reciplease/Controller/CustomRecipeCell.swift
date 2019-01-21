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
    @IBOutlet var recipeRating: [UIImageView]!

    func set(name: String, image: String, rating: Int) {
        recipeName.text = name
        do {
            let data = try Data(contentsOf: URL(string: image)!)
            recipeImage.image = UIImage(data: data) ?? UIImage(named: "noImage")!
        } catch {
            recipeImage.image = UIImage(named: "noImage")!
        }
        for index in 0 ... rating {
            recipeRating[index].image = UIImage(named: "star_true")
        }
    }
}
