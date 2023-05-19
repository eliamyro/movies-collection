//
//  FetchPopularMoviesUCTests.swift
//  FetchPopularMoviesUCTests
//
//  Created by Elias Myronidis on 19/5/23.
//

import Combine
import XCTest
@testable import movies_collection

final class FetchPopularMoviesUCTests: XCTestCase {

    private func arrange() -> (uc: FetchPopularMoviesUC,
                               repoMock: MoviesRepoMock) {
        let moviesRepoMock = MoviesRepoMock()

        DInjection.shared = DInjection(empty: true)
            .register(MoviesRepo.self) { moviesRepoMock }
        return (FetchPopularMoviesUCImp(), moviesRepoMock)
    }

    func testFetchMoviesSuccess() {
        let arr = arrange()

        var movie = APIMovie()
        movie.id = 123
        movie.title = "Hello there"

        var movieResponse = APIMoviesResponse()
        movieResponse.results = [movie]

        var movieResponse2 = APIMoviesResponse()
        movieResponse2.results = []

        arr.repoMock.stub.fetchPopularMovies = {
            Just(movieResponse)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        }

        let actualResult = arr.uc.execute(page: 1)

        waitForValue(of: actualResult, value: movieResponse)
    }

    func testFetchMoviesFailed() {
        let arr = arrange()

        let exp = expectation(description: "Fails")

        arr.repoMock.stub.fetchPopularMovies = {
            Fail(error: RequestError.invalidResponse).eraseToAnyPublisher()
        }

        _ = arr.uc.execute(page: 1).sink { completion in
            guard case .failure(let error) = completion else { return }
            XCTAssertEqual(error, RequestError.invalidResponse)
            exp.fulfill()
        } receiveValue: { _ in
            XCTFail("Expected to fail")
        }

        waitForExpectations(timeout: 2)
    }
}
