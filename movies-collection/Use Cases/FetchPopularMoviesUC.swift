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
    let repo = MoviesRepoImp()

    func execute(page: Int, completed: @escaping (Result<APIMoviesResponse, RequestError>) -> Void) {
        print("FetchPopularMoviesUCImp")
        repo.fetchPopularMovies(page: page, completed: completed)
    }
}
