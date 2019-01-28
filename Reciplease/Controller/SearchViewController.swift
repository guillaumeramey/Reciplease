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
    @IBOutlet weak var ingredientButton: UIButton!
    @IBOutlet weak var selectCourseButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeSliderStackView: UIStackView!

    var ingredients = [String]()
    var maxTotalTimeInSeconds = 0 {
        willSet {
            timeLabel.text = newValue.convertToTimeString()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        self.title = "Reciplease"
        for button in buttons {
            button.layer.cornerRadius = 5
        }
        maxTotalTimeInSeconds = Int(timeSlider.value)
        timeSliderStackView.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromSearchToResults" {
            let resultsVC = segue.destination as! ResultsViewController
            resultsVC.ingredients = ingredients
            if timeSwitch.isOn {
                resultsVC.maxTotalTimeInSeconds = maxTotalTimeInSeconds
            }
            resultsVC.selectedCourses = courses.filter { $0.isSelected }
        }
        if segue.identifier == "segueFromSearchToCourses" {
            let coursesVC = segue.destination as! CoursesViewController
            coursesVC.delegate = self
        }
    }

    private func showClearButton() {
        if ingredientButton.tag == 1 {
            ingredientButton.tag = 0
            UIView.transition(with: ingredientButton, duration: 0.5, options: .transitionFlipFromRight, animations: {
                self.ingredientButton.setImage(UIImage(named: "Button_clear_white"), for: .normal)
            }, completion: nil)
        }
    }

    private func showAddButton() {
        if ingredientButton.tag == 0 {
            ingredientButton.tag = 1
            UIView.transition(with: ingredientButton, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.ingredientButton.setImage(UIImage(named: "Button_add_white"), for: .normal)
            }, completion: nil)
        }
    }

    // clear list or add ingredient to it depending on button tag
    @IBAction func ingredientButtonPressed(_ sender: UIButton!) {
        if ingredientButton.tag == 0 {
            ingredients.removeAll()
            ingredientsTableView.reloadData()
        } else {
            if newIngredient.text != "" {
                ingredients.insert(newIngredient.text!, at: 0)
                ingredientsTableView.reloadData()
                newIngredient.text = ""
                dismissKeyboard(UITapGestureRecognizer())
            }
        }
    }

    @IBAction func timeSwitchValueChanged(_ sender: UISwitch) {
        timeSliderStackView.isHidden = sender.isOn ? false : true
    }

    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
        maxTotalTimeInSeconds = Int(sender.value)
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
        newIngredient.text == "" ? showClearButton() : showAddButton()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        showAddButton()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientButtonPressed(UIButton())
        return true
    }

}

extension Int {
    func convertToTimeString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let timeString = hours > 0 ? "\(hours) hr \(minutes) min" : "\(minutes) min"

        return timeString
    }
}

extension SearchViewController: CoursesViewControllerDelegate {
    func setCourseButtonTitle(with title: String) {
        selectCourseButton.setTitle(title, for: .normal)
    }
}


/*
 allowedAllergy[] :
 Specifying an allowedAllergy[] parameter means that search results will only include recipes whose ingredients are allowed for that allergy. This parameter must be set equal to a searchValue in the Search Metadata Dicionary and can be repeated more than once to specify more than one allergy.

 To search for “Onion Soup” recipes that are Dairy-Free and Gluten-Free append &allowedAllergy[]=396^Dairy-Free&allowedAllergy[]=393^Gluten-Free

 For example:
 http://api.yummly.com/v1/api/recipes?_app_id=YOUR_ID&_app_key=YOUR_APP_KEY&q=onion+soup&allowedAllergy[]=396^Dairy-Free&allowedAllergy[]=393^Gluten-Free

 The allowedAllergy[] parameter must be set equal to a searchValue found in the Yummly Search Metadata Dictionaries. An example of an allowedAllergy[] searchValue is "393^Gluten-Free" to indicate you want Gluten Free recipes. To access the metadata dictionary for allowedAllergy[] searchValues, use the following end point: http://api.yummly.com/v1/api/metadata/allergy?_app_id=YOUR_ID&_app_key=YOUR_APP_KEY

 Supported Allergies
 Dairy, Egg, Gluten, Peanut, Seafood, Sesame, Soy, Sulfite, Tree Nut, Wheat
 */
