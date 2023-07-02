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
                NavigationLink {
                    DetailView(meal: meal)
                        .environmentObject(viewModel)
                } label: {
                    MealRow(meal: meal)
                }
            }
            .navigationTitle("Meals")
        }.environmentObject(viewModel)
    }
}

struct DessertList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            DessertList(viewModel: MenuViewModel())
        }
    }
}

struct MealRow: View {
    @ObservedObject var meal: MealViewModel
    var body: some View {
        HStack{
            MealImageView(meal: meal)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxWidth:100)
            VStack(alignment: .leading){
                Text(meal.name)
                    .font(.headline)
            }
        }
    }
}
