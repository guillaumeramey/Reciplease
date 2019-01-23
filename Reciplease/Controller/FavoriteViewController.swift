//
//  FavoriteViewController.swift
//  
//
//  Created by Guillaume Ramey on 15/01/2019.
//

import UIKit

class FavoriteViewController: UITableViewController {

    @IBOutlet weak var noFavoriteLabel: UILabel!

    var recipes = [Recipe]()
    var selectedRow: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "customRecipeCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavigationBar()
        recipes = Favorite.recipes
        noFavoriteLabel.isHidden = recipes.isEmpty ? false : true
        tableView.reloadData()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeSelected" {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.recipe = recipes[selectedRow]
        }
    }
}
