//
//  FetchMediaUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 9/5/23.
//

import Foundation

protocol FetchMediaUC {
    func execute(query: String, page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void)
}

class FetchMediaUCImp: FetchMediaUC {
    let repo = MoviesRepoImp()

    func execute(query: String, page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void) {
        repo.fetchMedia(query: query, page: page, completed: completed)
    }
}
