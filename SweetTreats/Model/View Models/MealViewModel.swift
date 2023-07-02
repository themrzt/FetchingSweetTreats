//
//  MealViewModel.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import Foundation
import SwiftUI

@MainActor class MealViewModel: ObservableObject{
    var meal: Meal
    @Published var name: String
    @Published var category: String = ""
    @Published var area: String? = nil
    @Published var instructions: [String] = []
    @Published var tags: [String] = []
    @Published var youTubeURL: String? = nil
    @Published var ingredients: [Ingredient] = []
    @Published var source: String? = nil
    @Published var imageSource: String? = nil
    @Published var dateModified: String? = nil
    @Published var thumbnailImageURL: URL? = nil
    @Published var cachedImageData: Data? = nil
    
    
    init(meal: Meal){
        self.meal = meal
        self.name = meal.name
    }
    
    func getDetails(){
        Task{
            let recipe = try await NetworkManager.shared.fetchDetails(mealID: meal.mealID)
            self.category = recipe.category
            self.area = recipe.area ?? nil
            //Line breaks from the API seem to like to use new lines than paragraph breaks. Heavy-handed here, but much easier to read for the user.
            let cleanInstructions = recipe.instructions?.replacingOccurrences(of: "\r\n\r\n", with: "\r\n") ?? ""
            let recipeInstructions = cleanInstructions.components(separatedBy: "\r\n").compactMap({$0.replacingOccurrences(of: "\r", with: "")
                    .replacingOccurrences(of: "\n", with: "")
            })
            self.instructions =  recipeInstructions ?? []
            self.ingredients = recipe.ingredients
            self.tags = recipe.tags ?? []
            self.youTubeURL = recipe.youTube ?? nil
            self.source = recipe.source
            self.imageSource = recipe.imageSource
            if let recipeImageString = recipe.mealThumb{
                self.thumbnailImageURL = URL(string: recipeImageString)
            }else{
                if let mealThumb = URL(string: meal.thumbnailURL){
                    self.thumbnailImageURL = mealThumb
                }
            }
        }
    }
    
    func cacheImage() async throws {
        guard let image = try await NetworkManager.shared.downloadImage(from: meal.thumbnailURL) else{return}
        self.cachedImageData = image.pngData()
    
    }
    
    func fetchCachedImage() -> UIImage{
        guard let data = cachedImageData, let image = UIImage(data: data) else{
            return UIImage(systemName: "fork.knife")!
        }
        return image
    }
}
