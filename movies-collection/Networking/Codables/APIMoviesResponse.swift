//
//  APIMoviesResponse.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

// MARK: - APIMoviesResponse

struct APIMoviesResponse: Codable, Equatable {
    var page: Int?
    var results: [APIMovie]?
}

// MARK: - APIMovie

struct APIMovie: Codable {
    var id: Int?
    var title: String?  // Movie title
    var name: String?   // Tv show name
    var posterPath: String?
    var backdropPath: String?
    var releaseDate: String?
    var firstAirDate: String?
    var voteAverage: Double?
    var voteCount: Int?
    var mediaType: String?

    enum CodingKeys: String, CodingKey {
        case id, title, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case mediaType = "media_type"
    }

    var getMediaType: String {
        mediaType == "tv" ? "tv" : "movie"
    }
}

extension APIMoviesResponse {
    static func == (lhs: APIMoviesResponse, rhs: APIMoviesResponse) -> Bool {
        lhs.page == rhs.page && lhs.results?.count ?? 0 == rhs.results?.count ?? 0
    }
}

extension APIMovie {
    var isFavorite: Bool {
        return CoreDataManager.shared.isFavorite(id: self.id ?? 0)
    }
}
