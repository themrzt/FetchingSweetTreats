//
//  Meal.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 6/30/23.
//

import Foundation

struct Meal: Identifiable, Codable, Hashable{

    var id: String { return mealID }
    var mealID: String
    var name: String
    var thumbnailURL: String
    var imageData: Data?
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(mealID: String, name: String, thumbnailURL: String) {
        self.mealID = mealID
        self.name = name
        self.thumbnailURL = thumbnailURL
        
    }
    
    #if DEBUG
    static let preview = Meal(mealID: "52959", name: "Creamy Heart Soup", thumbnailURL: "https://oyster.ignimgs.com/mediawiki/apis.ign.com/the-legend-of-zelda-breath-of-the-wild-2/0/0f/59-recipe-totk.jpg")
    #endif
    
}

extension Meal{
    struct CodingData: Codable{
        var mealID: String
        var name: String
        var thumbnailURL: String
        var meal: Meal{
            Meal(mealID: mealID, name: name, thumbnailURL: thumbnailURL)
        }
        enum CodingKeys: String, CodingKey{
            case mealID = "idMeal"
            case name = "strMeal"
            case thumbnailURL = "strMealThumb"
        }
    }
}

struct MealResponse: Codable{
    var meals: [Meal.CodingData]
}
