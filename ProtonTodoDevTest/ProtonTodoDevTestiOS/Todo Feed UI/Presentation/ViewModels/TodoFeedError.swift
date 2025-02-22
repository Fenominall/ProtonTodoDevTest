//
//  TodoFeedError.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/12/25.
//

import Foundation

enum TodoFeedError: Identifiable, Error, Equatable {
    case networkError
    case unmetDependencies(String)
    
    var id: String { localizedDescription }
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network Error"
        case .unmetDependencies:
            return "Unmet Dependencies"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Couldn't connect to server. Pleae try again later..."
        case .unmetDependencies(let dependenciesList):
            return "Please complete the following tasks first: \(dependenciesList)"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .networkError:
            return "Retry"
        case .unmetDependencies:
            return "Ok"
        }
    }
}
