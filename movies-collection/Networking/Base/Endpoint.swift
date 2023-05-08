//
//  Endpoint.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var queryItems: [URLQueryItem] { get }
    var header: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        "https"
    }

    var host: String {
        return "api.themoviedb.org"
    }

    var header: [String: String]? {
        return ["Accept": "application/json"]
    }
}
