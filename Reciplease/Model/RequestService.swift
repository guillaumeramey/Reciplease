//
//  SearchService.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 07/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol RequestServiceDelegate {
    func alertUser(title: String, message: String)
}

class RequestService {

    var delegate: RequestServiceDelegate?
    private let searchUrl = "https://api.yummly.com/v1/api/recipes"
    private let recipeUrl = "https://api.yummly.com/v1/api/recipe/"

    // API request to search for recipes using Alamofire
    func searchRecipes(with ingredients: [String], maxTime: Int32, selectedCourses: [Course], startIndex: Int, completion: @escaping ([Recipe]?) -> Void) {
        var parameters = "?"
        parameters += "_app_key=" + Constants.apiKey
        parameters += "&_app_id=" + Constants.apiAppId
        parameters += ingredients.isEmpty ? "" : "&q=" + ingredients.joined(separator: "+")
        parameters += maxTime > 0 ? "&maxTotalTimeInSeconds=" + maxTime.description : ""
        parameters += "&maxResult=10"
        parameters += "&start=\(startIndex)"
        parameters += selectedCourses.map {"&allowedCourse[]=course^course-" + $0.name}.joined()

        guard let url = (searchUrl + parameters).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            completion(nil)
            return
        }

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success (let value):
                let recipes = self.jsonToRecipeList(json: JSON(value))
                completion(recipes)
            case .failure:
                self.delegate?.alertUser(title: "Network error", message: "Impossible to get results.")
                completion(nil)
            }
        }
    }

    // Parse JSON into a list of recipes using SwiftyJSON
    private func jsonToRecipeList(json: JSON) -> [Recipe] {
        var recipes = [Recipe]()
        for match in json["matches"].arrayValue {
            let id = match["id"].stringValue
            let name = match["recipeName"].stringValue
            let imageSmall = URL(string: match["smallImageUrls"][0].string?.replacingOccurrences(of: "=s90", with: "") ?? "")
            let rating = match["rating"].int16Value
            let ingredients = match["ingredients"].arrayValue.map{$0.stringValue}.joined(separator: ", ")
            let totalTimeInSeconds = match["totalTimeInSeconds"].int32Value
            let course = match["attributes"]["course"][0].stringValue

            recipes.append(Recipe(id: id, name: name, imageSmall: imageSmall, rating: rating, ingredients: ingredients, totalTimeInSeconds: totalTimeInSeconds, course: course))
        }
        return recipes
    }

    // API request to get a specific recipe using Alamofire
    func getRecipeDetails(recipe: Recipe, completion: @escaping (Recipe?) -> Void) {
        let url = recipeUrl
            + recipe.id
            + "?_app_id=" + Constants.apiAppId
            + "&_app_key=" + Constants.apiKey

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success (let value):
                let recipe = self.updateRecipe(recipe, with: JSON(value))
                completion(recipe)
            case .failure:
                self.delegate?.alertUser(title: "Network error", message: "Impossible to get recipe details.")
                completion(nil)
            }
        }
    }

    // Update a recipe with a JSON using SwiftyJSON
    func updateRecipe(_ recipe: Recipe, with json: JSON) -> Recipe {
        recipe.numberOfServings = json["numberOfServings"].intValue
        recipe.totalTime = json["totalTime"].stringValue
        recipe.imageBig = json["images"][0]["hostedLargeUrl"].url
        recipe.ingredientLines = json["ingredientLines"].arrayValue.map{$0.stringValue}
        recipe.recipeURL = json["source"]["sourceRecipeUrl"].url
        return recipe
    }

    // Get an image from an URL using AlamoFire
    func getImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }
}
