//
//  SearchResults.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 13/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

struct SearchResultsJSON: Decodable {
    let attribution: [String : String] // keys : html, url, text, logo
    let totalMatchCount: Int
    let matches: [Match]

    struct Match: Decodable {
        let id: String
        let rating: Int
        let recipeName: String
        let smallImageUrls: [String]
        let ingredients: [String]
    }
}


/*
 {
 "criteria": {
     "q": "onion tomatoes pepper carrot",
     "allowedIngredient": null,
     "excludedIngredient": null
     },
 "matches": [
     {
         "imageUrlsBySize": {
             "90": "https://lh3.googleusercontent.com/t9F93Xs0KSU9NnqtiC11kK-lAfdxdKZ-GFSUcisE6xi-h6IwQMcMmCpzWS7ntV5e1ARhZsdfpBqATpx09-hLhQ=s90-c"
             },
         "sourceDisplayName": "Delightful Mom Food",
         "ingredients": [
             "tomatoes",
             "carrot",
             "white onion",
             "garlic cloves",
             "olive oil",
             "basil leaves",
             "Himalayan salt",
             "vegetable broth",
             "black pepper"
             ],
         "id": "Tomato-Basil-Soup-2632795",
         "smallImageUrls": [
             "https://lh3.googleusercontent.com/xxDKzpMXPe-vV4SIBaGkHTziapLWOlFCsDD9fJWWkot5laREg3Qta9SBjuqdl9UdhLwc0MzBLx10FycCx8wCc3E=s90"
             ],
         "recipeName": "Tomato Basil Soup",
         "totalTimeInSeconds": 3600,
         "attributes": {
             "course": [
                 "Soups"
                 ]
             },
         "flavors": null,
         "rating": 4
     },

 {
 "imageUrlsBySize": {
 "90": "https://lh3.googleusercontent.com/qTWAlYOBEYEUW9clKdq_LVXaUsUT6X84TVc4HajRegevpuOXLx7hkbWCtvMMww1L7rdF2jY1OznGo5d-di4f8A=s90-c"
 },
 "sourceDisplayName": "Cooking Classy",
 "ingredients": [
 "bell peppers",
 "medium carrots",
 "zucchini",
 "broccoli",
 "red onion",
 "olive oil",
 "Italian seasoning",
 "garlic",
 "salt",
 "freshly ground black pepper",
 "grape tomatoes",
 "fresh lemon juice"
 ],
 "id": "Roasted-Vegetables-2629766",
 "smallImageUrls": [
 "https://lh3.googleusercontent.com/CMUAWG4L296HQA9QY43gQYudTG4zxHkLgIrZXnefvGjtyt_i80tTyfHsFGy7X0-nUwcd3GKquHODY-Ni8VEcFR4=s90"
 ],
 "recipeName": "Roasted Vegetables",
 "totalTimeInSeconds": 2100,
 "attributes": {
 "course": [
 "Side Dishes"
 ]
 },
 "flavors": {
 "piquant": 0.16666666666666666,
 "meaty": 0.16666666666666666,
 "bitter": 0.16666666666666666,
 "sweet": 0.16666666666666666,
 "sour": 0.8333333333333334,
 "salty": 0.16666666666666666
 },
 "rating": 4
 }
 ],
 "facetCounts": {},
 "totalMatchCount": 21576,
 "attribution": {
 "html": "Recipe search powered by <a href='http://www.yummly.co/recipes'><img alt='Yummly' src='https://static.yummly.co/api-logo.png'/></a>",
 "url": "http://www.yummly.co/recipes/",
 "text": "Recipe search powered by Yummly",
 "logo": "https://static.yummly.co/api-logo.png"
 }
 }
 */
