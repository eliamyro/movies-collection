//
//  MoviesRepo.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import UIKit

protocol MoviesRepo {
    func fetchPopularMovies<T: Decodable>(page: Int, completed: @escaping (Result<T, RequestError>) -> Void)

    func fetchMedia<T: Decodable>(query: String, page: Int, completed: @escaping (Result<T, RequestError>) -> Void)

    func fetchDetails<T: Decodable>(id: Int, mediaType: String, completed: @escaping (Result<T, RequestError>) -> Void)

    func fetchVideos<T: Decodable>(id: Int, mediaType: String, completed: @escaping (Result<T, RequestError>) -> Void)

    func downloadImage(imageUrl: String, completed: @escaping ((UIImage?) -> Void))

    func fetchCredits<T: Decodable>(id: Int, mediaType: String, completed: @escaping (Result<T, RequestError>) -> Void)
}

class MoviesRepoImp: MoviesRepo {
    @Injected var httpClient: HTTPClient

    func fetchPopularMovies<T: Decodable>(page: Int, completed: @escaping (Result<T, RequestError>) -> Void) {
        httpClient.sendRequest(endpoint: MoviesEndpoint.popularMovies(page: page), responseType: T.self, completed: completed)
    }

    func fetchMedia<T: Decodable>(query: String, page: Int, completed: @escaping (Result<T, RequestError>) -> Void) {
        httpClient.sendRequest(endpoint: MoviesEndpoint.multiSearch(query: query, page: page), responseType: T.self, completed: completed)
    }

    func fetchDetails<T: Decodable>(id: Int, mediaType: String, completed: @escaping (Result<T, RequestError>) -> Void) {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaDetails(id: id, mediaType: mediaType), responseType: T.self, completed: completed)
    }

    func fetchVideos<T: Decodable>(id: Int, mediaType: String, completed: @escaping (Result<T, RequestError>) -> Void) {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaVideos(id: id, mediaType: mediaType), responseType: T.self, completed: completed)
    }

    func downloadImage(imageUrl: String, completed: @escaping ((UIImage?) -> Void)) {
        httpClient.downloadImage(endpoint: MoviesEndpoint.downloadImage(imageUrl: imageUrl), completed: completed)
    }

    func fetchCredits<T: Decodable>(id: Int, mediaType: String, completed: @escaping (Result<T, RequestError>) -> Void) {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaCredits(id: id, mediaType: mediaType), responseType: T.self, completed: completed)
    }
}
