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
            MealImageView(meal: meal){ phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                case .failure(let error):
                    Image(systemName: "exclamationmark.triangle.fill")
                }
            }
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
