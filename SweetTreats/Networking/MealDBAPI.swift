//
//  MealDBAPI.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/1/23.
//

import Foundation

enum MealNetworkError: LocalizedError{
    case invalidRequest
    case notFound
    case missingCategory
    case noResults
    case connectionIssue
    case ateAllDesserts
    case rateLimitExceeded
    case deviceOffline
}

extension MealNetworkError{
    var errorDescription: String?{
        switch self{
        case .ateAllDesserts:
            return "Dunno, mate. Maybe you've eaten everything?"
        case .missingCategory:
            return "This seems like a category that doesn't exist."
        case .noResults:
            return "No matching results"
        case .connectionIssue:
            return "Sorry, there seems to be a connection issue. Try again later."
        case .rateLimitExceeded:
            return "Ah, sorry. Server says you've exceeded your rate limit. I blame Elon."
        case .invalidRequest:
            return "Sorry. Invalid request."
        case .notFound:
            return "Your request can't be found."
        case .deviceOffline:
            return "It looks like your device may be offline. Check your connection and try your request again."
        }
    }
}

enum MealDBEndpoint: String{
    //In a production environment, the API key would need to be handled differently here. For user-scoped keys, we'd be using the system keychain. For the purposes of this sample project, I'm using the "1" key provided for debugging by MealDB.
    
    private var baseURLString: String { return  "https://www.themealdb.com/api/json/v1/1"}
    
    case filteredCategories = "filter.php"
    case list = "list.php"
    case lookup = "lookup.php"
    
    var endPointPath: String {
        let endPoint = "/" + self.rawValue
        return baseURLString + endPoint
    }
    
    var url: URL? {
        return URL(string: endPointPath)
    }
}
