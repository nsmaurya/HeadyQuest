//
//  NetworkConnectivityManager.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation

enum ErrorState: Hashable, Equatable {
    case failure
    case noNetwork
    case emptyState
    case success
    case other(message: String)
    
    var hashValue: Int {
        switch self {
        case .failure:
            return 0
        case .noNetwork:
            return 1
        case .emptyState:
            return 2
        case .success:
            return 3
        case .other(_):
            return 4
        }
    }
    
    func getErrorMessage() -> String {
        switch self{
        case .failure:
            return "Something went wrong."
        case .noNetwork:
            return "Seems like you don't have an active internet connection."
        case .emptyState:
            return "No result found."
        case .other(let message):
            return message
        default:
            return ""
        }
    }
}
func ==(lhs: ErrorState, rhs: ErrorState) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
