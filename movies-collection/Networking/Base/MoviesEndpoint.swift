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
}

extension MoviesEndpoint: Endpoint {
    var host: String {
        switch self {
        case .popularMovies:
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
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .popularMovies(let page):
            return [
                URLQueryItem(name: "api_key", value: APIKey.shared.apiKey),
                URLQueryItem(name: "page", value: "\(page)")
            ]

        case .downloadImage:
            return []
        }
    }

    var method: RequestMethod {
        switch self {
        case .popularMovies, .downloadImage:
            return .get
        }
    }
}
