//
//  RequestServiceTests.swift
//  RecipleaseTests
//
//  Created by Guillaume Ramey on 10/02/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import XCTest
@testable import Reciplease

class RequestServiceTests: XCTestCase {

    var recipe: Recipe!

    override func setUp() {
        recipe = Recipe(id: "French-Onion-Soup-The-Pioneer-Woman-Cooks-_-Ree-Drummond-41364", name: "Test", imageSmall: URL(string: "test"), rating: 1, ingredients: "Test", totalTimeInSeconds: 1, course: "Test")
    }

    func testGetRecipeDetailsShouldUpdateRecipeWithRecipeURL() {
        // Given
        let requestService = RequestService()
        XCTAssertNil(recipe.recipeURL)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for request.")

        requestService.getRecipeDetails(recipe: recipe) { (recipe) in
            // Then
            XCTAssertNotNil(recipe?.recipeURL)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

    func testSearchRecipesShouldReturnARecipeArray() {
        // Given
        let requestService = RequestService()

        // When
        let expectation = XCTestExpectation(description: "Wait for request.")

        requestService.searchRecipes(with: [], maxTime: 0, selectedCourses: [], startIndex: 0) { (recipes) in
            // Then
            XCTAssertNotNil(recipes)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testGetImageShouldReturnAnImage() {
        // Given
        let requestService = RequestService()
        let imageUrl = URL(string: "https://lh3.googleusercontent.com/cORS-fY79K4KSu_wq-FtQhkPXACjwbXeSVMtF2KK0jZNqDBRwwEXKpBhxbylRRQveHLHLjJsB8_hLZLAarww=s90-c")!

        // When
        let expectation = XCTestExpectation(description: "Wait for request.")

        requestService.getImage(from: imageUrl) { (image) in
            // Then
            XCTAssertNotNil(image)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }
}
