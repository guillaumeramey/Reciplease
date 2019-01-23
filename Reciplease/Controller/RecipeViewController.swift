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

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isHidden = true
        getRecipe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.showNavigationBar()
    }
    
    private func getRecipe() {
        activityIndicator.startAnimating()
        SearchService().getRecipe(id: recipe.id, completion: { (recipeJSON) in
            if let recipeJSON = recipeJSON {
                self.updateRecipe(with: recipeJSON)
                self.displayRecipe()
                self.scrollView.isHidden = false
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
        recipe.recipeURL = json.source.sourceRecipeURL
    }

    private func displayRecipe() {
        recipeName.text = recipe.recipeName
        totalTime.text = recipe.totalTime
        if let urlString = recipe.imageBig, let url = URL(string: urlString) {
            recipeImage.load(url: url)
        }
        if let ingredientLines = recipe.ingredientLines {
            ingredients.text = "- " + ingredientLines.joined(separator: "\n- ")
        }
        if let numberOfServings = recipe.numberOfServings {
            servings.text = "\(numberOfServings) people"
        }
        updateFavoriteButtonColor()
    }

    private func updateFavoriteButtonColor() {
        if isFavorite {
            favoriteButton.tintColor = UIColor(named: "Color_button")
        } else {
            favoriteButton.tintColor = UIColor.lightGray
        }
    }

    @IBAction func favoriteButtonPressed() {
        isFavorite ? removeFromFavorites() : addToFavorites()
    }

    private func addToFavorites() {
        Favorite().create(from: recipe)
        updateFavoriteButtonColor()
    }

    private func removeFromFavorites() {
        if Favorite().deleteFavorite(with: recipe.id) {
            updateFavoriteButtonColor()
        } else {
            Alert.present(title: "Erreur", message: "Impossible de supprimer le favori", vc: self)
        }
    }

    @IBAction func instructionsButtonPressed(_ sender: Any) {
        guard let urlString = recipe.recipeURL, let url = URL(string: urlString) else {
            Alert.present(title: "Problème...", message: "Impossible d'ouvrir le lien vers les instructions.", vc: self)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
