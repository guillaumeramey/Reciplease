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

    func searchRecipes(with ingredients: [String], maxTime: Int, selectedCourses: [Course], startIndex: Int, completion: @escaping (SearchResultsJSON?) -> Void) {

        var parameters = "?"
        parameters += "_app_key=" + Constants.apiKey
        parameters += "&_app_id=" + Constants.apiAppId
        parameters += ingredients.isEmpty ? "" : "&q=" + ingredients.joined(separator: "+")
        parameters += maxTime > 0 ? "&maxTotalTimeInSeconds=" + maxTime.description : ""
        parameters += "&maxResult=10"
        parameters += "&start=\(startIndex)"
        for course in selectedCourses {
            parameters += "&allowedCourse[]=course^course-" + course.name
        }

        guard let url = (searchUrl + parameters).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            completion(nil)
            return
        }

        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success (let data):
                do {
                    let searchResultsJSON = try JSONDecoder().decode(SearchResultsJSON.self, from: data)
                    completion(searchResultsJSON)
                } catch let error {
                    self.delegate?.alertUser(title: "Data error", message: "Impossible to read results data.")
                    print("Erreur de formatage JSON : \(error)")
                    completion(nil)
                }
            case .failure (let error):
                self.delegate?.alertUser(title: "Network error", message: "Impossible to retrieve results.")
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }
    }

    func getRecipe(id: String, completion: @escaping (RecipeJSON?) -> Void) {

        let url = recipeUrl
            + id
            + "?_app_id=" + Constants.apiAppId
            + "&_app_key=" + Constants.apiKey

        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success (let data):
                do {
                    let recipeJSON = try JSONDecoder().decode(RecipeJSON.self, from: data)
                    completion(recipeJSON)
                } catch let error {
                    self.delegate?.alertUser(title: "Data error", message: "Impossible to read recipe data.")
                    print("Erreur de formatage JSON : \(error)")
                    completion(nil)
                }
            case .failure (let error):
                self.delegate?.alertUser(title: "Network error", message: "Impossible to retrieve recipe.")
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }
    }

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
