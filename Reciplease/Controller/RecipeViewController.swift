//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 15/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit
import CoreData

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
    private var isFavorite: Bool {
        return Favorite.all.contains(where: {$0.id == recipe.id})
    }
    private var recipeUrl: URL? {
        if let urlString = recipe.recipeURL, let url = URL(string: urlString) {
            return url
        } else {
            Alert.present(title: "Invalid URL", message: "The link for this recipe is invalid.", vc: self)
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        getRecipe()
    }
    
    private func getRecipe() {
        activityIndicator.startAnimating()
        SearchService().getRecipe(id: recipe.id, completion: { (recipeJSON) in
            if let recipeJSON = recipeJSON {
                self.setUpRecipe(with: recipeJSON)
                self.displayRecipe()
                self.scrollView.isHidden = false
            } else {
                self.recipeName.text = "Error getting recipe fom results"
            }
            self.activityIndicator.stopAnimating()
        })
    }

    private func setUpRecipe(with json: RecipeJSON) {
        recipe.numberOfServings = json.numberOfServings
        recipe.totalTime = json.totalTime
        recipe.imageBig = json.images[0].imageUrlsBySize["360"]
        recipe.ingredientLines = json.ingredientLines
        recipe.recipeURL = json.source.sourceRecipeURL
    }

    private func displayRecipe() {
        recipeName.text = recipe.recipeName
        totalTime.text = recipe.totalTime

        if let urlString = recipe.imageBig, let url = URL(string: urlString) {
            SearchService().getImage(from: url, completion: { (image) in
                if let image = image {
                    self.recipeImage.image = image
                } else {
                    self.recipeImage.isHidden = true
                }
            })
        } else {
            recipeImage.isHidden = true
        }

        if let ingredientLines = recipe.ingredientLines {
            ingredients.text = "- " + ingredientLines.joined(separator: "\n- ")
        }
        if let numberOfServings = recipe.numberOfServings {
            servings.text = "\(numberOfServings) people"
        }
        updateFavoriteButtonImage()
    }


    @IBAction func favoriteButtonPressed() {
        isFavorite ? removeFromFavorites() : addToFavorites()
    }

    private func addToFavorites() {
        Favorite().create(from: recipe)
        updateFavoriteButtonImage()
    }

    private func removeFromFavorites() {
        if Favorite().delete(id: recipe.id) {
            updateFavoriteButtonImage()
        } else {
            Alert.present(title: "Erreur", message: "Impossible de supprimer la recette des favoris.", vc: self)
        }
    }

    private func updateFavoriteButtonImage() {
        favoriteButton.image = isFavorite ? UIImage(named: "star_true") : UIImage(named: "star_false")
    }

    @IBAction func instructionsButtonPressed(_ sender: Any) {
        if let url = recipeUrl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func shareButtonPressed(_ sender: Any) {
        if let url = recipeUrl {
            let message = "Look at this recipe I found on Reciplease !"
            let items: [Any] = [message, url]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
        }
    }
}

extension RecipeViewController: SearchServiceDelegate {
    func alertUser(title: String, message: String) {
        Alert.present(title: title, message: message, vc: self)
    }
}
