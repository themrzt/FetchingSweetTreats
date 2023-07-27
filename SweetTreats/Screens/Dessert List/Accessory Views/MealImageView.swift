//
//  MealImageView.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

struct MealImageView<Content: View>: View {
    @ObservedObject var meal: MealViewModel
    @StateObject private var manager = CacheManager()
    
    let content: (AsyncImagePhase) -> Content
    
    init(meal: MealViewModel, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content){
        self.meal = meal
        self.content = content
    }
    
    var body: some View {
        Group{
            switch manager.currentState{
            case .loading:
                content(.empty)
            case .success(let data):
                #if os(iOS)
                if let image = UIImage(data: data){
                    content(.success(Image(uiImage: image)))
                }
                #elseif os(macOS)
                if let image = NSImage(data: data){
                    content(.success(Image(nsImage: image)))
                }
                #endif
            case .failed(let error):
                content(.failure(error))
            default:
                content(.empty)
            }
        }.task{
            await manager.load(meal.thumbnailImageURL?.absoluteString ?? "")
        }
    }
}

struct MealImageView_Previews: PreviewProvider {
    static var previews: some View {
        MealImageView(meal: MealViewModel(meal: Meal.preview)){ _ in EmptyView()}
    }
}
