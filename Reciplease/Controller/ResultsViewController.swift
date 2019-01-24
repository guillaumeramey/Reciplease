//
//  ResultsViewController.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 23/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {
    
    @IBOutlet weak var noResultsLabel: UILabel!

    var ingredients = [String]()
    var maxTotalTimeInSeconds = 0
    var recipes = [Recipe]()
    var selectedRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "customRecipeCell")

        searchRecipes()
    }

    private func searchRecipes() {
        SearchService().searchRecipes(with: ingredients, maxTime: maxTotalTimeInSeconds) { (searchResultsJSON) in
            if let searchResultsJSON = searchResultsJSON {
                self.recipes = searchResultsJSON.matches
                self.tableView.reloadData()
            } else {
                print("Error getting results from search")
            }
            self.noResultsLabel.isHidden = self.recipes.isEmpty ? false : true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeSelected" {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.recipe = recipes[selectedRow]
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRecipeCell", for: indexPath) as! CustomRecipeCell
        cell.set(recipe: recipes[indexPath.row])
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "recipeSelected", sender: self)
    }
}

extension ResultsViewController: SearchServiceDelegate {
    func alertUser(title: String, message: String) {
        Alert.present(title: title, message: message, vc: self)
    }
}
