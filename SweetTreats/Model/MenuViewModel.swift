//
//  MealViewModel.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

class MenuViewModel: ObservableObject{
    @Published var meals = [MealViewModel]()
    @Published private(set) var error: MealNetworkError?
    @Published var hasError: Bool = false
    
    init(){
        fetchMeals()
    }
    
    private func fetchMeals(){
        Task{
            do{
                let results = try await NetworkManager.shared.fetchMeals(with: "Dessert")
                await updateMeals(meals: results)
            }catch{
                
                print(error)
                DispatchQueue.main.async{
                    if let error = error as? MealNetworkError{
                        self.error = error as? MealNetworkError
                        self.hasError.toggle()
                    } else{
                        self.error = MealNetworkError.deviceOffline
                        self.hasError.toggle()
                    }
                }
            }
        }
    }
    
    @MainActor private func updateMeal(mealID: String){
        guard let index = meals.firstIndex(where: {$0.meal.mealID == mealID}) else{return}
        var mealModel = meals[index]
        mealModel.getDetails()
        meals.remove(at: index)
        meals.insert(mealModel, at: index)
    }
    
    func updateRegionalMeals(region: String){
        Task{
            let meals = try await NetworkManager.shared.fetchRegionalMeals(region: region)
            await updateRegionalMeals(meals: meals)
        }
    }
    
    @MainActor private func updateRegionalMeals(meals: [Meal]){
        let models = meals.compactMap{ MealViewModel(meal: $0) }
        let newIDs = models.map{$0.meal.mealID}
        let existing = self.meals.map{$0.meal.mealID}
        let uniques = newIDs.filter{ !existing.contains($0)}
        print("That's \(uniques.count)")
        print("Uniques: \(uniques.map{$0})")
        print("Existing: \(existing.map{$0})")
        var newMeals = self.meals.filter{ uniques.contains($0.meal.mealID)}
        print("And \(newMeals.count) new meals")
        _ = newMeals.map{ self.meals.append($0)}
    }
    
    @MainActor private func updateMeals(meals: [Meal]){
        let observables = meals.map{ meal in
            return MealViewModel(meal: meal)
        }
        self.meals = observables
    }
}
