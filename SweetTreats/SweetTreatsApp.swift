//
//  SweetTreatsApp.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import SwiftUI

@main
struct SweetTreatsApp: App {
    @StateObject var viewModel: MenuViewModel = MenuViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MenuViewModel())
        }
    }
}
