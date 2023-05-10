//
//  MoviesEndpoint.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

enum MoviesEndpoint {
    case popularMovies(page: Int)
    case downloadImage(imageUrl: String)
    case multiSearch(query: String, page: Int)
}

extension MoviesEndpoint: Endpoint {
    var host: String {
        switch self {
        case .popularMovies, .multiSearch:
            return "api.themoviedb.org"
        case .downloadImage:
            return "image.tmdb.org"
        }
    }

    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"

        case .downloadImage(let imageUrl):
            return "/t/p/w1280\(imageUrl)"

        case .multiSearch:
            return "/3/search/multi"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .popularMovies(let page):
            return [
                URLQueryItem(name: "api_key", value: APIKey.shared.apiKey),
                URLQueryItem(name: "page", value: "\(page)")
            ]

        case .multiSearch(let query, let page):
            return [
                URLQueryItem(name: "api_key", value: APIKey.shared.apiKey),
                URLQueryItem(name: "query", value: "\(query)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]

        case .downloadImage:
            return []
        }
    }

    var method: RequestMethod {
        switch self {
        case .popularMovies, .downloadImage, .multiSearch:
            return .get
        }
    }
}
