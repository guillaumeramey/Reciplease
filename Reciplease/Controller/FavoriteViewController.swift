//
//  FavoriteViewController.swift
//  
//
//  Created by Guillaume Ramey on 15/01/2019.
//

import UIKit

class FavoriteViewController: UITableViewController {

    class SectionData {
        var isExpanded: Bool
        var title: String
        var recipes: [Recipe]

        init(title: String, recipes: [Recipe]) {
            self.title = title
            self.recipes = recipes
            isExpanded = true
        }
    }

    var selectedRecipe: Recipe!
    private var tableViewData = [SectionData]()
    private let cellId = "customRecipeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }

    private func updateData() {
        var data = [SectionData]()
        for course in Constants.courses {
            let sectionRecipes = Favorite.recipes.filter{$0.course == course.name}
            if sectionRecipes.isEmpty == false {
                let title = sectionRecipes[0].course ?? "No category"
                data.append(SectionData(title: title, recipes: sectionRecipes))
            }
        }
        tableViewData = data
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.recipeSelectedSegue {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.recipe = selectedRecipe
        }
    }

    @objc private func toggleExpansion(_ sender: UIButton) {
        tableViewData[sender.tag].isExpanded.toggle()
        tableView.reloadSections([sender.tag], with: .none)
    }

    @IBAction func expandAll() {
        toggleAllSections(expand: true)
    }

    @IBAction func collapseAll() {
        toggleAllSections(expand: false)
    }

    private func toggleAllSections(expand: Bool) {
        _ = tableViewData.map {$0.isExpanded = expand}
        tableView.reloadSections(IndexSet(0 ..< tableViewData.count), with: .automatic)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return cellCourseView(section: section)
    }

    private func cellCourseView(section: Int) -> UIView {
        let button = UIButton()
        button.setTitle(tableViewData[section].title, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Medium", size: 25)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(toggleExpansion), for: .touchUpInside)
        button.tag = section
        button.backgroundColor = Constants.courses.first(where: {$0.name == tableViewData[section].title})?.color

        let imageName = tableViewData[section].isExpanded ? "Button_collapse" : "Button_expand"
        let image = UIImageView(image: UIImage(named: imageName))
        button.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -10).isActive = true

        return button
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].isExpanded ? tableViewData[section].recipes.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomRecipeCell
        cell.set(recipe: tableViewData[indexPath.section].recipes[indexPath.row])
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = tableViewData[indexPath.section].recipes[indexPath.row]
        performSegue(withIdentifier: Constants.recipeSelectedSegue, sender: self)
    }
}
