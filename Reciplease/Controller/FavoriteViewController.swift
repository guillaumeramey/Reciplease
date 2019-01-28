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

    var tableViewData = [SectionData]()
    var selectedRecipe: Recipe!
    let cellId = "customRecipeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTableViewData()
        tableView.reloadData()
        // patch : bug when displaying cells
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }

    private func setTableViewData() {
        var data = [SectionData]()
        for course in courses {
            let sectionRecipes = Favorite.recipes.filter{$0.course == course.name}
            if sectionRecipes.isEmpty == false {
                let title = sectionRecipes[0].course ?? "No category"
                data.append(SectionData(title: title, recipes: sectionRecipes))
            }
        }
        tableViewData = data
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeSelected" {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.recipe = selectedRecipe
        }
    }

    @objc private func toggleExpansion(_ sender: UIButton) {
        tableViewData[sender.tag].isExpanded.toggle()
        if tableViewData[sender.tag].isExpanded {
            tableView.reloadSections([sender.tag], with: UITableView.RowAnimation.bottom)
        } else {
            tableView.reloadSections([sender.tag], with: UITableView.RowAnimation.top)
        }
    }

    @IBAction func expandAll() {
        toggleAllSections(isExpanded: true)
    }

    @IBAction func collapseAll() {
        toggleAllSections(isExpanded: false)
    }

    private func toggleAllSections(isExpanded: Bool) {
        _ = tableViewData.map {$0.isExpanded = isExpanded}
        tableView.reloadSections(IndexSet(0 ..< tableViewData.count), with: UITableView.RowAnimation.automatic)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = courses.first(where: {$0.name == tableViewData[section].title})?.color
        let button = UIButton()
        button.setTitle(tableViewData[section].title, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = UIFont(name: "Noteworthy-Bold", size: 20)
        button.setTitleColor(UIColor(named: "Color_button_text"), for: .normal)
        button.addTarget(self, action: #selector(toggleExpansion), for: .touchUpInside)
        button.tag = section
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
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
        performSegue(withIdentifier: "recipeSelected", sender: self)
    }
}
