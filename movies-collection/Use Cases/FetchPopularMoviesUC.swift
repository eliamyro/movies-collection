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
}

class FetchPopularMoviesUCImp: FetchPopularMoviesUC {

    @Injected var repo: MoviesRepo

    func execute(page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        repo.fetchPopularMovies(page: page)
    }
}
