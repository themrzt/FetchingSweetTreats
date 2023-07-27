//
//  CacheManager.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/26/23.
//

import Foundation

final class CacheManager: ObservableObject{
    enum CurrentState{
        case loading
        case failed(error: Error)
        case success(data: Data)
    }
    
    @Published private(set) var currentState: CurrentState?
    private let networkManager = NetworkManager.shared
    
    @MainActor
    func load(_ url: String, cache: ImageCache = .shared) async{
        self.currentState = .loading
        
        if let existing = cache.object(for: url as NSString){
            self.currentState = .success(data: existing)
            #if DEBUG
            print("Loaded cached photo for \(url)")
            #endif
            return
        }
        
        guard let photoURL = URL(string: url) else{
            self.currentState = .failed(error: MealNetworkError.invalidRequest)
            return
        }
        
        do{
            #if DEBUG
            print("loading remotely")
            #endif
            let data = try await networkManager.fetchThumbnail(url: photoURL)
            
            self.currentState = .success(data: data)
            cache.set(object: data as NSData, for: url as NSString)
            #if DEBUG
            print("Asked to cache")
            #endif
        }catch{
            self.currentState = .failed(error: error)
        }
    }
}

extension CacheManager.CurrentState: Equatable{
    static func == (lhs: CacheManager.CurrentState, rhs: CacheManager.CurrentState) -> Bool{
        switch (lhs, rhs){
        case (.loading, .loading):
            return true
        case (let .success(lhsData), let .success(rhsData)):
            return lhsData == rhsData
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
