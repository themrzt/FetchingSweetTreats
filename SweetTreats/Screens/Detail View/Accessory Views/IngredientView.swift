//
//  IngredientView.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

struct IngredientView: View {
    @EnvironmentObject var meal: MealViewModel
    var body: some View {
        VStack(alignment: .leading){
            Text("Ingredients")
                .bold()
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(meal.ingredients, id:\.self){ ingredient in
                VStack(alignment: .leading){
                    Text(ingredient.name)
                        .bold()
                    Text(ingredient.measure)
                        .foregroundColor(.secondary)
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView()
            .environmentObject(MealViewModel(meal: Meal.preview))
    }
}
