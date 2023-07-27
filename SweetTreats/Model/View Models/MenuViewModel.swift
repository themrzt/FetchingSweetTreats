//
//  MealViewModel.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

class MenuViewModel: ObservableObject{
    private let defaultsKey = "SavedTreatsMenu"
    @Published var meals = [MealViewModel]()
    @Published var regions = [String]()
    @Published private(set) var error: MealNetworkError?
    @Published var hasError: Bool = false
    
    init(){
        loadSavedMenu()
        Task{
            await fetchMeals()
            await postUpdatedNotification()
        }
    }
    
    @MainActor
    private func postUpdatedNotification(){
        NotificationCenter.default.post(name: Notification.Name("UpdatedRecipesNotification"), object: nil)
    }
    
    func saveMenu(){
        let menu = TreatsMenu(meals: meals.compactMap{$0.meal})
        let encoder = JSONEncoder()
        do{
            let savedMenu = try encoder.encode(menu)
            UserDefaults.standard.setValue(savedMenu, forKey: defaultsKey)
        }catch{
            print(error)
        }
    }
    
    private func loadSavedMenu(){
        guard let treatMenuData = UserDefaults.standard.data(forKey: defaultsKey) else{ print("❌ could not load"); return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do{
            let menu = try decoder.decode(TreatsMenu.self, from: treatMenuData)
            self.meals = menu.meals.compactMap{MealViewModel(meal: $0)}
        }catch{
            print("❌ Could not load \(error)")
        }
        
    }
    
    private func fetchMeals() async{
        do{
            let newMeals = try await NetworkManager.shared.fetchMeals(with: "Dessert")
            if self.meals.count > 0{
                let unique = newMeals.filter { newMeal in
                    let existing = meals.map{ $0.meal.mealID }
                    if existing.contains(newMeal.mealID){
                        return false
                    }else{
                        return true
                    }
                }
                if unique.count > 0{
                    await updateMeals(meals: unique)
                }
            }else{
                await updateMeals(meals: newMeals)
            }
        }catch{
            DispatchQueue.main.async{
                if let error = error as? MealNetworkError{
                    self.error = error
                    self.hasError.toggle()
                } else{
                    self.error = MealNetworkError.deviceOffline
                    self.hasError.toggle()
                }
            }
        }
    }
    
    @MainActor private func updateMeals(meals: [Meal]){
        let observables = meals.map{ meal in
            return MealViewModel(meal: meal)
        }
        self.meals = observables.sorted(by: {$0.name < $1.name})
        let regions =  Set(meals.compactMap{$0.recipe?.area})
        self.regions.append(contentsOf: regions)
        self.regions.sort(by: {$0 < $1})
    }

}
