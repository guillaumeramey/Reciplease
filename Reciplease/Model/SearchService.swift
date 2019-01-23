//
//  SearchService.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 07/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation
import Alamofire

class SearchService {

    private let searchUrl = "https://api.yummly.com/v1/api/recipes"
    private let recipeUrl = "https://api.yummly.com/v1/api/recipe/"
    private let apiAppId = "f53e19ba"
    private let apiKey = valueForAPIKey("yummly")

    func searchRecipes(with ingredients: [String], completion: @escaping (SearchResultsJSON?) -> Void) {

        #warning("TODO: Convertir en UTF8")
        let url = searchUrl
            + "?_app_id=" + apiAppId
            + "&_app_key=" + apiKey
            + "&q=" + ingredients.joined(separator: "+")
            + "&excludedIngredient[]=" + "onion%20soup%20mix"
            + "&excludedIngredient[]=" + "gruyere"

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let searchResultsJSON = try JSONDecoder().decode(SearchResultsJSON.self, from: jsonData)
                        completion(searchResultsJSON)
                    } catch let error {
                        print("Erreur de formatage JSON : \(error)")
                        completion(nil)
                    }
                }
            case .failure(let error):
                #warning("TODO : Implémenter une alerte")
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }
    }

    func getRecipe(id: String, completion: @escaping (RecipeJSON?) -> Void) {

        let url = recipeUrl
            + id
            + "?_app_id=" + apiAppId
            + "&_app_key=" + apiKey

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let recipeDetailJSON = try JSONDecoder().decode(RecipeJSON.self, from: jsonData)
                        completion(recipeDetailJSON)
                    } catch let error {
                        print("Erreur de formatage JSON : \(error)")
                        completion(nil)
                    }
                }
            case .failure(let error):
                #warning("TODO : Implémenter une alerte")
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }
    }

}
