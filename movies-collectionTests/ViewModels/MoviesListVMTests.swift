//
//  MoviesListVMTests.swift
//  movies-collectionTests
//
//  Created by Elias Myronidis on 19/5/23.
//

import Combine
import XCTest
@testable import movies_collection

// swiftlint:disable identifier_name large_tuple
final class MoviesListVMTests: XCTestCase {
    var cancellable: AnyCancellable?

    private func arrange() -> (vm: MoviesListVM,
                               popularMoviesUCMock: FetchPopularMoviesUCMock,
                               fetchMediaUCMock: FetchMediaUCMock) {
        let popularMoviesUCMock = FetchPopularMoviesUCMock()
        let fetchMediaUCMock = FetchMediaUCMock()
        let deleteFromDbUCMock = DeleteFavoriteMediaFromDBUCMock()
        let saveMediaToDbUCMock = SaveFavoriteMediaToDbUCMock()

        DInjection.shared = DInjection(empty: true)
            .register(FetchPopularMoviesUC.self) { popularMoviesUCMock }
            .register(FetchMediaUC.self) { fetchMediaUCMock }
            .register(DeleteFavoriteMediaFromDbUC.self) { deleteFromDbUCMock }
            .register(SaveFavoriteMediaToDbUC.self) { saveMediaToDbUCMock }

        return (MoviesListVM(), popularMoviesUCMock, fetchMediaUCMock)
    }

    func testFetchPopularMoviesSuccess() {
        let r = arrange()

        r.popularMoviesUCMock.stub.execute = { Just(APIMoviesResponse.fakeAPIMovieResponse)
            .setFailureType(to: RequestError.self)
            .eraseToAnyPublisher()
        }

        let expectation = expectation(description: "Fetch popular movies")

        r.vm.fetchPopularMovies()

        cancellable = r.vm.$apiMovies.sink { movies in
            if movies == APIMoviesResponse.fakeAPIMovieResponse.results {
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 2)
    }

    func testMediaSuccess() {
        let r = arrange()

        r.fetchMediaUCMock.stub.execute = { Just(APIMoviesResponse.fakeAPIMovieResponse)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        }

        let expectation = expectation(description: "Fetch media")

        r.vm.fetchMedia()

        cancellable = r.vm.$apiMovies.sink { media in
            if media == APIMoviesResponse.fakeAPIMovieResponse.results {
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 3)
    }
}
