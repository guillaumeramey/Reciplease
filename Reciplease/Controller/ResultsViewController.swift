//
//  ResultsViewController.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 23/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {

    // MARK: - PROPERTIES
    var ingredients = [String]()
    var selectedCourses = [Course]()
    var maxTotalTimeInSeconds: Int32 = 0
    private var recipes = [Recipe]()
    private var selectedRow: Int!
    private var isLoading = false
    private var startIndex = 0
    private let cellId = "customRecipeCell"
    private let requestService = RequestService()

    // MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

    // request new data
    private func searchRecipes() {
        requestService.searchRecipes(with: ingredients, maxTime: maxTotalTimeInSeconds, selectedCourses: selectedCourses, startIndex: startIndex) { (recipes) in
            if let recipes = recipes {
                self.recipes.append(contentsOf: recipes)
                self.updateTableView()
            } else {
                Alert.present(title: "Network error", message: "Something went wrong, verify your connexion.", vc: self)
            }
            self.isLoading = false
        }
    }

    // add the data to the tableview
    private func updateTableView() {
        tableView.beginUpdates()
        for row in startIndex ..< recipes.count {
            tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
        tableView.endUpdates()
        startIndex = recipes.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.recipeSelectedSegue {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.recipe = recipes[selectedRow]
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomRecipeCell
        cell.setCell(with: recipes[indexPath.row])
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: Constants.recipeSelectedSegue, sender: self)
    }

    // fetch new data when the user scrolls
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let boundsHeight = scrollView.bounds.size.height

        if isLoading == false && offSetY + (boundsHeight * 1.5) > contentHeight {
            isLoading = true
            searchRecipes()
        }
    }
}

// MARK: - 
extension ResultsViewController: RequestServiceDelegate {
    func alertUser(title: String, message: String) {
        Alert.present(title: title, message: message, vc: self)
    }
}
