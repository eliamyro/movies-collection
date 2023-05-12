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
    case mediaDetails(id: Int, mediaType: String)
    case mediaVideos(id: Int, mediaType: String)
    case youtube(key: String)
    case mediaCredits(id: Int, mediaType: String)
}

extension MoviesEndpoint: Endpoint {
    var host: String {
        switch self {
        case .popularMovies, .multiSearch, .mediaDetails, .mediaVideos, .mediaCredits:
            return "api.themoviedb.org"
        case .downloadImage:
            return "image.tmdb.org"
        case .youtube:
            return "www.youtube.com"
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

        case .mediaDetails(let id, let mediaType):
            return "/3/\(mediaType)/\(id)"

        case .mediaVideos(let id, let mediaType):
            return "/3/\(mediaType)/\(id)/videos"

        case .youtube(let key):
            return "/embed/\(key)"

        case .mediaCredits(let id, let mediaType):
            return "/3/\(mediaType)/\(id)/credits"

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

        case .downloadImage, .youtube:
            return []

        case .mediaDetails, .mediaVideos, .mediaCredits:
            return [
                URLQueryItem(name: "api_key", value: APIKey.shared.apiKey)
            ]
        }
    }

    var method: RequestMethod {
        switch self {
        case .popularMovies, .downloadImage, .multiSearch, .mediaDetails, .mediaVideos, .youtube, .mediaCredits:
            return .get
        }
    }
}
