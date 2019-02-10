//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 15/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class RecipeViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var servings: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    // MARK: - PROPERTIES
    var recipe: Recipe!
    private var isFavorite: Bool {
        return Favorite.all.contains(where: {$0.id == recipe.id})
    }
    private var recipeUrl: URL? {
        if let url = recipe.recipeURL {
            return url
        } else {
            Alert.present(title: "Invalid URL", message: "The link for this recipe is invalid.", vc: self)
            return nil
        }
    }
    private let requestService = RequestService()
    private lazy var coreDataStack = CoreDataStack(modelName: Constants.modelName)

    // MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        getRecipe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteButtonImage()
    }
    
    private func getRecipe() {
        activityIndicator.startAnimating()
        requestService.getRecipeDetails(recipe: recipe, completion: { (recipe) in
            if let recipe = recipe {
                self.recipe = recipe
                self.displayRecipe()
                self.scrollView.isHidden = false
            } else {
                self.recipeName.text = "Error getting recipe fom results"
            }
            self.activityIndicator.stopAnimating()
        })
    }

    private func displayRecipe() {
        recipeName.text = recipe.recipeName
        totalTime.text = recipe.totalTime

        if let url = recipe.imageBig {
            requestService.getImage(from: url, completion: { (image) in
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

    // MARK: - ACTIONS
    @IBAction func favoriteButtonPressed() {
        let success = isFavorite ? recipe.deleteFromFavorites(coreDataStack: coreDataStack) : recipe.addToFavorites(coreDataStack: coreDataStack)
        if success {
            updateFavoriteButtonImage()
        } else {
            Alert.present(title: "Erreur", message: "Impossible de modifier les favoris.", vc: self)
        }
    }

    private func updateFavoriteButtonImage() {
        let imageString = isFavorite ? "Button_star_true" : "Button_star_false"
        favoriteButton.image = UIImage(named: imageString)
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

// MARK: -
extension RecipeViewController: RequestServiceDelegate {
    func alertUser(title: String, message: String) {
        Alert.present(title: title, message: message, vc: self)
    }
}
