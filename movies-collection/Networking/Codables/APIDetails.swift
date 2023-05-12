//
//  APIDetails.swift
//  movies-collection
//
//  Created by Elias Myronidis on 10/5/23.
//

import Foundation

struct APIDetails: Codable {
    var id: Int?
    var backdropPath: String?
    var posterPath: String?
    var title: String? // Movie
    var name: String?  // TV
    var overview: String?
    var genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case id, title, name, overview, genres
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }

    // MARK: - Helper

    var summary: String {
        overview ?? ""
    }

    var genre: String {
        genres?.first?.name ?? "Unknown"
    }

    var posterUrl: String {
        backdropPath ?? ""
    }

    var mediaTitle: String {
        title ?? name ?? ""
    }
}

struct Genre: Codable {
    var id: Int?
    var name: String?
}
