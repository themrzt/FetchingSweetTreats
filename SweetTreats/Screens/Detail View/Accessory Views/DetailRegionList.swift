//
//  DetailRegionList.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

struct DetailRegionList: View {
    @ObservedObject var viewModel: MenuViewModel
    @State var area: String = ""
    @State private var similarMeals = [MealViewModel]()
    var body: some View {
        List{
            ForEach(similarMeals, id: \.meal.id){ meal in
                NavigationLink{
                    DetailView(meal: meal)
                        .environmentObject(viewModel)
                } label:{
                    MealRow(meal: meal)
                }
            }
        }
        .onAppear{
            Task{
                let meals = viewModel.meals.filter{$0.area == area}
                //try? await NetworkManager.shared.fetchRegionalMeals(region: area).compactMap({MealViewModel(meal: $0)})
//                if let meals = meals{
                    updateMeals(meals: meals)
//                }
                
            }
           
        }
        .navigationTitle("More \(area) Desserts")
    }
    
    private func updateMeals(meals: [MealViewModel]){
        let mealIDs = meals.compactMap{ $0.meal.mealID }
            let matches = viewModel.meals.filter{ mealIDs.contains($0.meal.mealID)}
        self.similarMeals = matches
    }
}

struct DetailRegionList_Previews: PreviewProvider {
    static var previews: some View {
        DetailRegionList(viewModel: MenuViewModel(), area: "British")
            
    }
}
