//
//  APICastResponse.swift
//  movies-collection
//
//  Created by Elias Myronidis on 12/5/23.
//

import Foundation

class APICreditsResponse: Codable {
    var id: Int?
    var cast: [APICast]?
}

class APICast: Codable {
    var id: Int?
    var name: String?
    var character: String?
}

extension APICreditsResponse {
    var castModels: [CastModel] {
        guard let cast = cast else { return [] }
        return cast.map { CastModel(cast: $0) }
    }
}
