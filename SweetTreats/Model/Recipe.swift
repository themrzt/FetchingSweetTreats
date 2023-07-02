//
//  MealRecipe.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 6/30/23.
//

import Foundation

struct Recipe: Codable{
    //Note: Absent full API documentation, properties that may be critical to display are being assumed to have a value. At the callsite, display-dependent items should be filtered for empty, while elements that can be assumed optional will be handled by the view model.
    var id: String { return idMeal }
    var idMeal: String
    var name: String
    var drinkAlternate: String?
    var category: String
    var area: String?
    var instructions: String?
    var mealThumb: String?
    var tags: [String]?
    var youTube: String?
    var ingredients: [Ingredient]
    var source: String?
    var imageSource: String?
    var isCreativeCommons: String?
    var dateModified: String?
}

extension Recipe{
    
    /*The MealDB API lists its recipes and measurements across up to 20 key value pairs. Rather than writing an extensive list of CodingKeys, the following initializer converts those into an Ingredient. This Codable struct takes an ingredient name and a measurement.
     
     This approach isn't without downsides. It doesn't, for instance, validate that the response has both an ingredient and a measurement. This solution puts priority on the ingredient name. The order on the list of ingredients in the response is not preserved, but this is arguably not a critical component of a recipe.
     */
    init(from decoder: Decoder) throws{
        let container = try decoder.singleValueContainer()
        let rawMealDict = try container.decode([String : String?].self)
        
        //Convenience keys for capturing the ingredient and measurement keys
        let ingredientPrefix = "strIngredient"
        let measurePrefix = "strMeasure"
        
        var newIngredients: [Ingredient] = []
        
        let ingredientKeys = rawMealDict.keys.filter{ $0.hasPrefix(ingredientPrefix)}
        
        //A while loop here is valid. Given the 20 key cap, however, a while loop seemed to add unnecessary complexity to code legibility.
        for index in 0...ingredientKeys.count{
            guard let name = rawMealDict[ingredientPrefix + "\(index + 1)"] as? String,
                  let measure = rawMealDict[measurePrefix + "\(index + 1)"] as? String,
                  !measure.isEmpty,
                  !name.isEmpty else{ break }
            newIngredients.append(Ingredient(name: name, measure: measure))
        }
        
        name = rawMealDict["strMeal"] as? String ?? ""
        idMeal = rawMealDict["idMeal"] as? String ?? ""
        drinkAlternate = rawMealDict["strDrinkAlternate"] as? String ?? nil
        category = rawMealDict["strCategory"] as? String ?? ""
        area = rawMealDict["strArea"] as? String ?? nil
        instructions = rawMealDict["strInstructions"] as? String ?? nil
        mealThumb = rawMealDict["strInstructions"] as? String ?? ""
        ingredients = newIngredients
        source = rawMealDict["strSource"] as? String ?? nil
        imageSource = rawMealDict["strImageSource"] as? String ?? nil
        isCreativeCommons = rawMealDict["strCreativeCommonsConfirmed"] as? String ?? nil
        dateModified = rawMealDict["dateModified"] as? String ?? nil
    }
}

struct RecipeResponse: Codable{
    var meals: [Recipe]
}
