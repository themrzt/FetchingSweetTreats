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
            ForEach(viewModel.meals, id: \.meal.id){ meal in
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
