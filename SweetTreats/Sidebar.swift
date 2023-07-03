//
//  Sidebar.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/3/23.
//

import SwiftUI

enum STNav: Hashable{
    case desserts
    case about
}

struct Sidebar: View {
    @Binding var selectedNav: STNav?
    
    var body: some View {
        List(selection: $selectedNav){
            NavigationLink(value: STNav.desserts){
                Label("Desserts", systemImage: "birthday.cake.fill")
            }
            NavigationLink(value: STNav.about){
                Label("About", systemImage: "info.circle.fill")
            }
        }.listStyle(.sidebar)
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar(selectedNav: .constant(.desserts))
    }
}
