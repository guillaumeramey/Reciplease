//
//  SearchService.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 07/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation
import Alamofire

protocol SearchServiceDelegate {
    func alertUser(title: String, message: String)
}

class SearchService {

    var delegate: SearchServiceDelegate?
    private let searchUrl = "https://api.yummly.com/v1/api/recipes"
    private let recipeUrl = "https://api.yummly.com/v1/api/recipe/"
    private let apiAppId = "f53e19ba"
    private let apiKey = valueForAPIKey("yummly")

    func searchRecipes(with ingredients: [String], maxTime: Int, completion: @escaping (SearchResultsJSON?) -> Void) {

        var urlString = searchUrl
            + "?_app_id=" + apiAppId
            + "&_app_key=" + apiKey
            + "&q=" + ingredients.joined(separator: "+")
        if maxTime > 0 {
            urlString += "&maxTotalTimeInSeconds=\(maxTime)"
        }
        //            + "&excludedIngredient[]=" + "onion%20soup%20mix"
        //            + "&excludedIngredient[]=" + "gruyere"

        // replace forbidden characters
        guard let url = formatUrl(urlString) else {
            self.delegate?.alertUser(title: "Request error", message: "Forbidden characters in request.")
            completion(nil)
            return
        }

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let searchResultsJSON = try JSONDecoder().decode(SearchResultsJSON.self, from: jsonData)
                        completion(searchResultsJSON)
                    } catch let error {
                        self.delegate?.alertUser(title: "Data error", message: "Impossible to read results data.")
                        print("Erreur de formatage JSON : \(error)")
                        completion(nil)
                    }
                }
            case .failure(let error):
                self.delegate?.alertUser(title: "Network error", message: "Impossible to retrieve results.")
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }
    }

    // replace forbidden characters
    private func formatUrl(_ urlString: String) -> URL? {
        if let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: encodeString) {
            return url
        }
        return nil
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
                        self.delegate?.alertUser(title: "Data error", message: "Impossible to read recipe data.")
                        print("Erreur de formatage JSON : \(error)")
                        completion(nil)
                    }
                }
            case .failure(let error):
                self.delegate?.alertUser(title: "Network error", message: "Impossible to retrieve recipe.")
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }
    }

}
