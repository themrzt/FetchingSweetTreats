//
//  ContentView.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 6/30/23.
//

import SwiftUI

struct DessertList: View {
    @ObservedObject var viewModel: MenuViewModel

    var body: some View {
        List{
            ForEach(viewModel.meals.sorted(by: {$0.name < $1.name}), id: \.meal.id){ meal in
                NavigationLink(value: meal){
                    MealRow(meal: meal)
                        .frame(alignment: .leading)
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
    }
}

struct DessertList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            DessertList(viewModel: MenuViewModel())
        }
    }
}
