//
//  MoviesRepo.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

protocol MoviesRepo {
    func fetchPopularMovies()
}

class MoviesRepoImp: MoviesRepo {
    private let httpClient = HTTPClientImp()

    func fetchPopularMovies() {
        print("MoviesRepoImp")
        httpClient.sendRequest(endpoint: MoviesEndpoint.popularMovies(page: 2), responseType: APIMoviesResponse.self)
    }
}
