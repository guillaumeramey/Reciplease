//
//  Course.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 24/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

class Course {
    let name: String
    var isSelected: Bool

    init(name: String) {
        self.name = name
        isSelected = false
    }
}

private let mainDishes = Course(name: "Main Dishes")
private let desserts = Course(name: "Desserts")
private let sideDishes = Course(name: "Side Dishes")
private let appetizers = Course(name: "Appetizers")
private let salads = Course(name: "Salads")
private let breakfastAndBrunch = Course(name: "Breakfast and Brunch")
private let breads = Course(name: "Breads")
private let soups = Course(name: "Soups")
private let beverages = Course(name: "Beverages")
private let condimentsAndSauces = Course(name: "Condiments and Sauces")
private let cocktails = Course(name: "Cocktails")
private let snacks = Course(name: "Snacks")
private let lunch = Course(name: "Lunch")

let courses = [appetizers, beverages, breads, breakfastAndBrunch, cocktails, condimentsAndSauces, desserts, lunch, mainDishes, salads, sideDishes, snacks, soups]

//    var courses: [(name: String, searchValue: String, isSelected: Bool)] = [
//        ("Appetizers", "", false),
//        ("Beverages", "", false),
//        ("Breads", "", false),
//        ("Breakfast and Brunch", "", false),
//        ("Cocktails", "", false),
//        ("Condiments and Sauces", "", false),
//        ("Lunch", "", false),
//        ("Main Dishes", "", false),
//        ("Salads", "", false),
//        ("Side Dishes", "", false),
//        ("Snacks", "", false),
//        ("Soups", "", false)]
