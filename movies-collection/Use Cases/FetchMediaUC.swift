//
//  FetchMediaUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 9/5/23.
//

import Combine
import Foundation

protocol FetchMediaUC {
    func execute(query: String, page: Int) -> AnyPublisher<APIMoviesResponse, RequestError>
    func execute(query: String, page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void)
}

class FetchMediaUCImp: FetchMediaUC {

    @Injected var repo: MoviesRepo

    func execute(query: String, page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        repo.fetchMedia(query: query, page: page)
    }

    func execute(query: String, page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void) {
        repo.fetchMedia(query: query, page: page, completed: completed)
    }
}
