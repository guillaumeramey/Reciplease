//
//  CoursesViewController.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 25/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

protocol CoursesViewControllerDelegate {
    func setCourseButtonTitle(with title: String)
}

class CoursesViewController: UIViewController {

    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var contentView: UIView!

    var delegate: CoursesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        courseTableView.reloadData()
    }

    private func setup() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    @IBAction func checkButtonPressed(_ sender: Any) {
        _ = Constants.courses.map { $0.isSelected = true }
        courseTableView.reloadData()
    }

    @IBAction func uncheckButtonPressed(_ sender: Any) {
        _ = Constants.courses.map { $0.isSelected = false }
        courseTableView.reloadData()
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        let selectedCourses = Constants.courses.filter{$0.isSelected}.count
        var title = ""
        if selectedCourses == Constants.courses.count || selectedCourses == 0 {
            title = "All"
        } else {
            title = selectedCourses.description
        }
        delegate?.setCourseButtonTitle(with: title)
        dismiss(animated: true, completion: nil)
    }
}

extension CoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
        let course = Constants.courses[indexPath.row]
        cell.textLabel?.text = course.name
        cell.accessoryType = course.isSelected ? .checkmark : .none
        cell.textLabel?.textColor = course.color
        return cell
    }
}

extension CoursesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Constants.courses[indexPath.row].isSelected.toggle()
        tableView.reloadData()
    }
}
