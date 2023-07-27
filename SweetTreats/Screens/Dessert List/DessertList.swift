//
//  ContentView.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 6/30/23.
//

import SwiftUI

struct DessertList: View {
    @ObservedObject var viewModel: MenuViewModel
    @State private var meals = [MealViewModel]()
    @State private var searchText = ""
    @State private var selectedArea: String? = nil

    let observer = NotificationCenter.default.publisher(for: Notification.Name("UpdatedRecipesNotification"))
    
    var body: some View {
        List{
            ForEach(meals, id: \.meal.id){ meal in
                NavigationLink(value: meal){
                    MealRow(meal: meal)
                        .frame(alignment: .leading)
                }
            }
        }
        .searchable(text: $searchText)
        .toolbar{
            ToolbarItem(placement: .primaryAction){
                Picker(selection: $selectedArea) {
                    Text("--").tag(Optional<String>(nil))
                    ForEach(viewModel.regions, id: \.self){ region in
                        Text(region).tag(region as String?)
                    }
                } label: {
                    Label("Filter by region", systemImage: "line.3.horizontal.decrease.circle")
                }

            }
        }
        .navigationTitle("Desserts")
        .navigationDestination(for: MealViewModel.self) { meal in
            DetailView(meal: meal)
                .environmentObject(viewModel)
        }
        .navigationDestination(for: String.self) { area in
            DetailRegionList(viewModel: viewModel, area: area)
        }
        .environmentObject(viewModel)
        .onReceive(observer){ _ in
            meals = viewModel.meals
        }
        .onChange(of: searchText, perform: { newValue in
            if !newValue.isEmpty{
                meals = viewModel.meals.filter{$0.name.localizedStandardContains(newValue)}
            }else{
                meals = viewModel.meals
            }
        })
        .onChange(of: selectedArea) { newValue in
            if newValue != nil{
                meals = meals.filter{$0.meal.recipe?.area == newValue}
            }else{
                meals = viewModel.meals
            }
        }
    }
}

struct DessertList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            DessertList(viewModel: MenuViewModel())
        }
    }
}
