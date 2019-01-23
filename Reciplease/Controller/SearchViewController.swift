//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 23/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var newIngredient: UITextField!
    @IBOutlet var buttons: [UIButton]!

    var ingredients = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        for button in buttons {
            button.layer.cornerRadius = 5
        }
    }

    @IBAction func addIngredient(_ sender: UIButton!) {
        if newIngredient.text != "" {
            ingredients.insert(newIngredient.text!, at: 0)
            ingredientsTableView.reloadData()
            newIngredient.text = ""
            newIngredient.resignFirstResponder()
        }
    }

    @IBAction func clearIngredients(_ sender: UIButton!) {
        ingredients.removeAll()
        ingredientsTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromSearchToResults" {
            let resultsVC = segue.destination as! ResultsViewController
            resultsVC.ingredients = ingredients
        }
    }
}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        cell.textLabel?.text = ingredients[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        newIngredient.resignFirstResponder()
    }
}
