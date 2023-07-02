//
//  DetailRegionList.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

struct DetailRegionList: View {
    @EnvironmentObject var viewModel: MenuViewModel
    @State var area: String?
    var body: some View {
        List{
            ForEach(viewModel.meals.filter{$0.area == area ?? ""}, id: \.meal.id){ meal in
                NavigationLink{
                    DetailView(meal: meal)
                } label:{
                    MealRow(meal: meal)
                }
            }
        }
        .onAppear{
            Task{
                guard let area = area else{return}
                viewModel.updateRegionalMeals(region: area)
            }
        }
        .navigationTitle(area != nil ? "Also \(area!)" : "More like this")
    }
    
    
}

struct DetailRegionList_Previews: PreviewProvider {
    static var previews: some View {
        DetailRegionList(area: "British")
            .environmentObject(MenuViewModel())
    }
}
