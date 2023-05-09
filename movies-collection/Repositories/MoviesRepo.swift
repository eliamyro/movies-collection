//
//  MoviesRepo.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

protocol MoviesRepo {
    func fetchPopularMovies<T: Decodable>(page: Int, completed: @escaping (Result<T, RequestError>) -> Void)
}

class MoviesRepoImp: MoviesRepo {
    private let httpClient = HTTPClientImp()

    func fetchPopularMovies<T: Decodable>(page: Int, completed: @escaping (Result<T, RequestError>) -> Void) {
        print("MoviesRepoImp")
        httpClient.sendRequest(endpoint: MoviesEndpoint.popularMovies(page: page), responseType: T.self, completed: completed)

    }
}
