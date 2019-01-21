//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 15/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var servings: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()

        getRecipe()
    }

    private func getRecipe() {
        activityIndicator.startAnimating()
        SearchService().getRecipe(id: recipe.id, completion: { (recipeJSON) in
            if let recipeJSON = recipeJSON {
                self.updateRecipe(with: recipeJSON)
                self.displayRecipe()
            } else {
                self.recipeName.text = "Error getting recipe fom results"
            }
            self.activityIndicator.stopAnimating()
        })
    }

    private func updateRecipe(with json: RecipeJSON) {
        recipe.numberOfServings = json.numberOfServings
        recipe.totalTime = json.totalTime
        recipe.imageBig = json.images[0].hostedLargeURL
        recipe.ingredientLines = json.ingredientLines
    }

    private func displayRecipe() {
        recipeName.text = recipe.name
        recipeImage.load(url: URL(string: recipe.imageBig)!)
        ingredients.text = "- " + recipe.ingredientLines.joined(separator: "\n- ")
        totalTime.text = recipe.totalTime
        servings.text = "\(recipe.numberOfServings) people"
        
        favoriteButton.tintColor = recipe.isFavorite ? UIColor(named: "Color_favorite_true") : UIColor(named: "Color_favorite_false")
    }

    @IBAction func favoriteButtonPressed() {
        recipe.isFavorite ? removeFromFavorites() : addToFavorites()
        recipe.isFavorite.toggle()
    }

    private func addToFavorites() {
        favorites.append(recipe)
        favoriteButton.tintColor = UIColor(named: "Color_favorite_true")
    }

    private func removeFromFavorites() {
        if let index = favorites.firstIndex(where: {$0.id == recipe.id}) {
            favorites.remove(at: index)
        }
        favoriteButton.tintColor = UIColor(named: "Color_favorite_false")
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
