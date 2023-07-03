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
        AsyncImage(url: URL(string: meal.meal.thumbnailURL)){ phase in
            switch phase{
            case .empty:
                if meal.cachedImageData == nil{
                    ProgressView()
                }else{
                    Image(uiImage: meal.fetchCachedImage())
                }
            case .success(let image):
                image.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failure(_):
                Image(systemName: "fork.knife")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 100)
            @unknown default:
                Image(systemName: "birthday.cake")
                    .resizable()
                    .scaledToFit()
            }
        }.task{
            if meal.cachedImageData == nil{
                try? await self.meal.cacheImage()
                meal.cachedImageData = meal.fetchCachedImage().pngData()
            }
        }
    }
}

struct MealImageView_Previews: PreviewProvider {
    static var previews: some View {
        MealImageView(meal: MealViewModel(meal: Meal.preview))
    }
}
