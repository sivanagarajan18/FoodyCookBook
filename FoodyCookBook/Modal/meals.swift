//
//  GlobalStructs.swift
//  Foody cookBook
//
//  Created by Siva Nagarajan on 26/04/21.
//

import Foundation
import UIKit

class meals: Codable {
    struct meal: Codable {
        let idMeal, strMeal: String?
        let strDrinkAlternate: String?
        let strCategory, strArea, strInstructions: String?
        let strMealThumb: String?
        let strTags: String?
        let strYoutube: String?
        let strIngredient1, strIngredient2, strIngredient3, strIngredient4: String?
        let strIngredient5, strIngredient6, strIngredient7, strIngredient8: String?
        let strIngredient9, strIngredient10, strIngredient11, strIngredient12: String?
        let strIngredient13, strIngredient14, strIngredient15, strIngredient16: String?
        let strIngredient17, strIngredient18, strIngredient19, strIngredient20: String?
        let strMeasure1, strMeasure2, strMeasure3, strMeasure4: String?
        let strMeasure5, strMeasure6, strMeasure7, strMeasure8: String?
        let strMeasure9: String?
        let strMeasure10, strMeasure11, strMeasure12, strMeasure13: String?
        let strMeasure14, strMeasure15, strMeasure16, strMeasure17: String?
        let strMeasure18, strMeasure19, strMeasure20: String?
        let strSource: String?
        let strImageSource, strCreativeCommonsConfirmed, dateModified: String?
    }
    var meals: [meal]?
}

