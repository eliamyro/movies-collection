//
//  FetchPopularMoviesUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

protocol FetchPopularMoviesUC {
    func execute(page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void)
}

class FetchPopularMoviesUCImp: FetchPopularMoviesUC {
    @Injected var repo: MoviesRepo

    func execute(page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void) {
        repo.fetchPopularMovies(page: page, completed: completed)
    }
}
