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

    func searchRecipes(with ingredients: [String], maxTime: Int32, selectedCourses: [Course], startIndex: Int, completion: @escaping ([Recipe]?) -> Void) {

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

    private func jsonToRecipeList(json: JSON) -> [Recipe] {
        var recipes = [Recipe]()
        for match in json["matches"].arrayValue {
            if let imageSmall = match["smallImageUrls"][0].string?.replacingOccurrences(of: "=s90", with: ""), let imageSmallUrl = URL(string: imageSmall) {
                let recipe = Recipe(id: match["id"].stringValue,
                                    name: match["recipeName"].stringValue,
                                    imageSmall: imageSmallUrl,
                                    rating: match["rating"].int16Value,
                                    ingredients: match["ingredients"].arrayValue.map{$0.stringValue},
                                    totalTimeInSeconds: match["totalTimeInSeconds"].int32Value,
                                    course: match["attributes"]["course"][0].stringValue)
                recipes.append(recipe)
            }
        }
        return recipes
    }

    func getRecipeDetails(id: String, completion: @escaping (JSON?) -> Void) {

        let url = recipeUrl
            + id
            + "?_app_id=" + Constants.apiAppId
            + "&_app_key=" + Constants.apiKey

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success (let value):
                completion(JSON(value))
            case .failure:
                self.delegate?.alertUser(title: "Network error", message: "Impossible to get recipe details.")
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
