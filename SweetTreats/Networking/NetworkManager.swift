//
//  NetworkManager.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import Foundation
import SwiftUI

class NetworkManager{
    static let shared = NetworkManager()
    
    var cache = NSCache<NSString, UIImage>()
    
    private var decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    
    private func requestURL(for base: URL, queryItems: [URLQueryItem]?) throws -> URL{
        var requestURL: URL = base
        if #available(iOS 16.0, *){
            if let queryItems = queryItems{
                requestURL = base.appending(queryItems: queryItems)
                return requestURL
            }
        }else{
            var components = URLComponents(url: base, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else{ throw MealNetworkError.invalidRequest }
            requestURL = url
            return requestURL
        }
        return requestURL
    }
    
    
    func fetchMeals(with category: String) async throws -> [Meal]{
        //Returns an array of meals based on the string category supplied. If the category supplied does not exist, throws the error appropriately.
        guard let filterBase = URL(string: MealDBEndpoint.filteredCategories.endPointPath) else{ throw MealNetworkError.invalidRequest }
        
        let queryItem = URLQueryItem(name: "c", value: category)
        var requestURL = filterBase.appending(queryItems: [queryItem])
        
        
        do{
            let data = try await requestData(requestURL: requestURL)
            
            let meals = try decodeMeals(from: data)
            
            return meals
        }catch{
            print(error)
            throw error
        }
    }
    
    func fetchDetails(mealID: String) async throws -> Recipe{
        guard let detailsBase = URL(string: MealDBEndpoint.lookup.endPointPath) else{ throw MealNetworkError.invalidRequest }
        let queryItems = [URLQueryItem(name: "i", value: mealID)]
        let requestURL = try requestURL(for: detailsBase, queryItems: queryItems)

        do{
            let data = try await requestData(requestURL: requestURL)
            let recipe = try decodeMealDetails(from: data)
            return recipe
        }catch{
            print(error)
            throw error
        }
    }
    
    func fetchRegionalMeals(region: String) async throws -> [Meal]{
        guard let regionBase = URL(string: MealDBEndpoint.filteredCategories.endPointPath) else {throw MealNetworkError.invalidRequest}
        let queryItems = [URLQueryItem(name: "a", value: region)]
        let requestURL = try requestURL(for: regionBase, queryItems: queryItems)
        
        let data = try await requestData(requestURL: requestURL)
        let meals = try decodeMeals(from: data)
        print("Found \(meals.count) for \(region)")
        return meals
    }
    
    private func requestData(requestURL: URL) async throws -> Data{
        do{
            let (data, response) = try await URLSession.shared.data(from: requestURL)
            
            guard let response = response as? HTTPURLResponse else { throw MealNetworkError.invalidRequest }
           
            let status = response.statusCode
            
            guard status >= 200 && status < 300 else{
                print(status)
                if status == 429{
                    print("throwing at \(requestURL.absoluteString)")
                    throw MealNetworkError.rateLimitExceeded
                }
                throw MealNetworkError.notFound
            }
            
            return data
        }catch{
            print(error)
            throw error
        }
        
    }
    
    private func decodeMeals(from data: Data) throws -> [Meal]{
        do{
            let container = try decoder.decode(MealResponse.self, from: data)
            
            return container.meals.compactMap{$0.meal}
            
        }catch{
            print("❌ decoded meals: \(error)")
            throw error
        }
    }
    
    private func decodeMealDetails(from data: Data) throws -> Recipe{
        do{
            let container = try decoder.decode(RecipeResponse.self, from: data)
            
            if let recipe = container.meals.first{
                return recipe
            }else{
                throw MealNetworkError.invalidRequest
            }
            
        }catch{
            print("❌ decoded details: \(error)")
            throw error
        }
    }
    
    func downloadImage(from urlString: String) async throws -> UIImage?{
        if let image = cache.object(forKey: NSString(string: urlString)){
            print("Returning from cache: \(urlString)")
            return image
        }
        guard let url = URL(string: urlString) else{ return nil}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let uiImage = UIImage(data: data) else{ return nil}
        self.cache.setObject(uiImage, forKey: NSString(string: urlString))
        print("Cached: \(urlString)")
        return uiImage
    }
    
}
