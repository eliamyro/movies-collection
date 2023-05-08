//
//  MoviesEndpoint.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

enum MoviesEndpoint {
    case popularMovies(page: Int)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .popularMovies(let page):
            return [
                URLQueryItem(name: "api_key", value: APIKey.shared.apiKey),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }

    var method: RequestMethod {
        switch self {
        case .popularMovies:
            return .get
        }
    }
}
