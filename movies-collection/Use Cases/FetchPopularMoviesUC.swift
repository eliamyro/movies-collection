//
//  FetchPopularMoviesUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Combine
import Foundation

protocol FetchPopularMoviesUC {
    func execute(page: Int) -> AnyPublisher<APIMoviesResponse, RequestError>
    func execute(page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void)
}

class FetchPopularMoviesUCImp: FetchPopularMoviesUC {

    @Injected var repo: MoviesRepo

    func execute(page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        repo.fetchPopularMovies(page: page)
    }

    func execute(page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void) {
        repo.fetchPopularMovies(page: page, completed: completed)
    }
}
