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
    var recipes = [Recipe]()
    var selectedRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "customRecipeCell")

        searchRecipes()
    }

    private func searchRecipes() {
        SearchService().searchRecipes(with: ingredients) { (searchResultsJSON) in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customRecipeCell") as? CustomRecipeCell else {
            return UITableViewCell()
        }
        cell.set(recipe: recipes[indexPath.row])
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "recipeSelected", sender: self)
    }
}
