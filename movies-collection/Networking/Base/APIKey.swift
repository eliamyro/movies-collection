//
//  APIKey.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

struct APIKey {
    static let shared = APIKey()

    private init() {}

    let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
}
