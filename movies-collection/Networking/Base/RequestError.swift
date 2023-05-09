//
//  RequestError.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

enum RequestError: Error {
    case invalidURL
    case unableToComplete(error: Error)
    case invalidResponse
    case invalidData
    case decodingError(error: Error)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "The url was invalid"
            
        case .unableToComplete(let error):
            return "Request unable to complete with error: \(error)"
            
        case .invalidResponse:
            return "Invalid response from the server. Please try again."
            
        case .invalidData:
            return "The data received from the server was invalid. Please try again."
            
        case .decodingError(let error):
            return "Failed decoding data with error: \(error)"
        }
    }
}
