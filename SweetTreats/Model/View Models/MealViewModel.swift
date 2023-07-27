//
//  MealViewModel.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import Foundation
import SwiftUI

class MealViewModel: ObservableObject, Hashable{
    
    @Published var meal: Meal
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
    @Published var cachedImageData: Data?
    
    
    init(meal: Meal){
        self.meal = meal
        self.name = meal.name
        guard let recipe = meal.recipe else{return}
        self.instructions = recipe.instructions?.components(separatedBy: "\r\n") ?? []
        self.ingredients = recipe.ingredients
        self.category = recipe.category
        self.area = recipe.area
        self.thumbnailImageURL = URL(string: meal.thumbnailURL)
    }
    
    static func == (lhs: MealViewModel, rhs: MealViewModel) -> Bool {
        return lhs.meal.id == rhs.meal.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(meal.mealID)
    }
    
    func cacheImage() async throws {
        guard let image = try await NetworkManager.shared.downloadImage(from: meal.thumbnailURL) else{ throw MealNetworkError.notFound }
        guard let data = image.pngData() else{ return}
        DispatchQueue.main.async{
            self.cachedImageData = data
        }
    }
    
    func fetchCachedImage() -> UIImage{
        guard let data = cachedImageData, let image = UIImage(data: data) else{
            return UIImage(systemName: "fork.knife")!
        }
        return image
    }
    
    func youtubeLink() -> URL?{
        guard let string = youTubeURL, let url = URL(string: string) else{ return nil}
        return url
    }
}
