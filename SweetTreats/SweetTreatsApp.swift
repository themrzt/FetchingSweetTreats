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
    @Environment(\.scenePhase) var phase
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MenuViewModel())
        }
        .onChange(of: phase) { newValue in
            switch newValue{
            case .background:
                viewModel.saveMenu()
            default:
                print("You should probably handle this before going to the Mac")
            }
        }
    }
}
