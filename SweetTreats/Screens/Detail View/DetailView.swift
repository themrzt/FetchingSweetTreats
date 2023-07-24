//
//  DetailView.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

enum SelectedDetailView: String, Hashable, CaseIterable{
    case instructions = "Instructions"
    case ingredients = "Ingredients"
}

struct DetailView: View {
    @EnvironmentObject var menuViewModel: MenuViewModel
    @ObservedObject var meal: MealViewModel
    @SceneStorage("SelectedDetailView") var selectedView: SelectedDetailView = .instructions
    
    var body: some View {
        ScrollView{
            MealImageView(meal: meal)
            AboutMealStrip(viewModel: menuViewModel)
            Picker("Viewing", selection: $selectedView) {
                ForEach(SelectedDetailView.allCases, id:\.self){ detail in
                    Text(detail.rawValue).tag(detail)
                }
            }.pickerStyle(.segmented)
                .padding(.horizontal)
            
            switch selectedView {
                case .instructions:
                    VStack(alignment: .leading){
                        Text("Instructions")
                            .font(.title)
                            .bold()
    
                        ForEach(meal.instructions, id:\.self){ instructionStep in
                            Text(instructionStep)
                                .padding(.bottom, 5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                case .ingredients:
                    IngredientView()
            }
        }
        .navigationTitle(meal.name)
        .environmentObject(menuViewModel)
        .environmentObject(meal)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(meal: MealViewModel(meal: Meal.preview))
        }
    }
}
