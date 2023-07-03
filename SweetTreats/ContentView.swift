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
    @State private var selectedNavigation: STNav? = .desserts
    @State private var selectedTab: Int = 1
    @State private var needsToShowError = false
    @State private var splitViewVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        Group{
            if horizontalSizeClass == .regular{
                iPad
                    .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
                        Button("OK"){}
                    }
            }else{
                iPhone
                    .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
                        Button("OK"){}
                    }
            }
        }
    }
    
    var iPad: some View{
        NavigationSplitView {
            Sidebar(selectedNav: $selectedNavigation)
        } content: {
            if selectedNavigation == .desserts{
                DessertList(viewModel: viewModel)
            }else{
                AboutView()
            }
        } detail: {
            if selectedNavigation == .desserts{
                NavigationStack(path: $navigationPath){
                    VStack{
                        Text("Make a selection to begin")
                    }
                }
            }else{
                EmptyView()
            }
        }
    }
    
    var iPhone: some View{
        TabView(selection: $selectedTab){
            NavigationStack{
                DessertList(viewModel: viewModel)
                    .navigationTitle("Desserts")
            }.tabItem {
                Label("Desserts", systemImage: "birthday.cake.fill")
            }
            .tag(1)
            NavigationStack{
                AboutView()
            }.tabItem {
                Label("About", systemImage: "info.circle.fill")
            }
            .tag(2)
        }.onChange(of: selectedTab) { newValue in
            if newValue == 1{
                selectedNavigation = .desserts
            }else{
                selectedNavigation = .about
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MenuViewModel())
    }
}
