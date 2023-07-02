//
//  MealRow.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/2/23.
//

import SwiftUI

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

struct MealRow_Previews: PreviewProvider {
    static var previews: some View {
        MealRow(meal: MealViewModel(meal: Meal.preview))
    }
}
