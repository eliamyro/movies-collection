//
//  MoviesRepo.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import UIKit

protocol MoviesRepo {
    func fetchPopularMovies<T: Decodable>(page: Int, completed: @escaping (Result<T, RequestError>) -> Void)

    func downloadImage(imageUrl: String, completed: @escaping ((UIImage?) -> Void))
}

class MoviesRepoImp: MoviesRepo {
    private let httpClient = HTTPClientImp.shared

    func fetchPopularMovies<T: Decodable>(page: Int, completed: @escaping (Result<T, RequestError>) -> Void) {
        print("MoviesRepoImp")
        httpClient.sendRequest(endpoint: MoviesEndpoint.popularMovies(page: page), responseType: T.self, completed: completed)
    }

    func downloadImage(imageUrl: String, completed: @escaping ((UIImage?) -> Void)) {
        httpClient.downloadImage(endpoint: MoviesEndpoint.downloadImage(imageUrl: imageUrl), completed: completed)
    }
}