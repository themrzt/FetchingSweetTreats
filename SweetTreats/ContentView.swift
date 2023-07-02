//
//  ContentView.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var viewModel: MenuViewModel
    @State private var needsToShowError = false
    
    var body: some View {
        if horizontalSizeClass == .regular{
            iPad
        }else{
            iPhone
                .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
                    Button("OK"){
                        
                    }
                }
        }
    }
    
    var iPad: some View{
        Text("iPad")
    }
    
    var iPhone: some View{
        TabView{
            NavigationStack{
                DessertList(viewModel: viewModel)
                    .navigationTitle("Desserts")
            }.tabItem {
                Label("Desserts", systemImage: "birthday.cake.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MenuViewModel())
    }
}
