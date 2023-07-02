//
//  MealImageView.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

struct MealImageView: View {
    @ObservedObject var meal: MealViewModel
    var body: some View {
        if meal.cachedImageData != nil{
            cachedImage
        }else{
            asyncImage
        }
    }
    
    var cachedImage: some View{
        Image(uiImage: meal.fetchCachedImage())
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
    }
    
    var asyncImage: some View{
        AsyncImage(url: URL(string: meal.meal.thumbnailURL)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } placeholder: {
            ProgressView()
        }
    }
}

struct MealImageView_Previews: PreviewProvider {
    static var previews: some View {
        MealImageView(meal: MealViewModel(meal: Meal.preview))
    }
}
