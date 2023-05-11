//
//  APIVideosResponse.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Foundation

class APIVideosResponse: Codable {
    var id: Int?
    var results: [APIVideo]?
}

class APIVideo: Codable {
    var id: String?
    var key: String?
}
