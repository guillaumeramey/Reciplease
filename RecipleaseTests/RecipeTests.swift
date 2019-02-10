//
//  RecipeTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Ramey on 10/02/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeTests: XCTestCase {

    var coreDataStack: CoreDataStack!
    var recipe: Recipe!

    override func setUp() {
        coreDataStack = TestCoreDataStack()
        recipe = Recipe(id: "Test", name: "Test", imageSmall: URL(string: "test"), rating: 1, ingredients: "Test", totalTimeInSeconds: 1, course: "Test")
    }

    override func tearDown() {
        coreDataStack = nil
    }

    func testRecipeToFavorite() {
        let addSuccess = recipe.addToFavorites(coreDataStack: coreDataStack)
        XCTAssertTrue(addSuccess)

        let deleteSuccess = recipe.deleteFromFavorites(coreDataStack: coreDataStack)
        XCTAssertTrue(deleteSuccess)
    }
}
