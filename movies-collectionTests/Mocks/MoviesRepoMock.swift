//
//  MoviesRepoMock.swift
//  movies-collectionTests
//
//  Created by Elias Myronidis on 19/5/23.
//

import Combine
import Foundation
import UIKit
@testable import movies_collection

class MoviesRepoMock: MoviesRepo {
    public let stub = Stub()

    public init() {}

    public class Stub {
        @Unwrapable public var fetchPopularMovies: (() -> AnyPublisher<APIMoviesResponse, RequestError>)?
    }

    func fetchPopularMovies(page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        return stub.$fetchPopularMovies.safeValue()()
    }

    // TODO: Add more tests

    func fetchMedia(query: String, page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        return Empty().eraseToAnyPublisher()
    }

    func fetchDetails(id: Int, mediaType: String) -> AnyPublisher<APIDetails, RequestError> {
        return Empty().eraseToAnyPublisher()
    }

    func fetchVideos(id: Int, mediaType: String) -> AnyPublisher<APIVideosResponse, RequestError> {
        return Empty().eraseToAnyPublisher()
    }

    func downloadImage(imageUrl: String) -> AnyPublisher<UIImage?, Never> {
        return Empty().eraseToAnyPublisher()
    }

    func fetchCredits(id: Int, mediaType: String) -> AnyPublisher<APICreditsResponse, RequestError> {
        return Empty().eraseToAnyPublisher()
    }

    func deleteFavoriteMediaFromDb(id: Int) -> AnyPublisher<Bool, Never> {
        return Empty().eraseToAnyPublisher()
    }

    func saveFavoriteMediaToDb(media: APIMovie) -> AnyPublisher<Bool, Never> {
        return Empty().eraseToAnyPublisher()
    }
}
