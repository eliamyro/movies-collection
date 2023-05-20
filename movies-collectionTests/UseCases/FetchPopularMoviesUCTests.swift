//
//  FetchPopularMoviesUCTests.swift
//  FetchPopularMoviesUCTests
//
//  Created by Elias Myronidis on 19/5/23.
//

import Combine
import XCTest
@testable import movies_collection

// swiftlint:disable identifier_name
final class FetchPopularMoviesUCTests: XCTestCase {

    private func arrange() -> (uc: FetchPopularMoviesUC,
                               repoMock: MoviesRepoMock) {
        let moviesRepoMock = MoviesRepoMock()

        DInjection.shared = DInjection(empty: true)
            .register(MoviesRepo.self) { moviesRepoMock }
        return (FetchPopularMoviesUCImp(), moviesRepoMock)
    }

    func testFetchMoviesSuccess() {
        let r = arrange()

        r.repoMock.stub.fetchPopularMovies = {
            Just(APIMoviesResponse.fakeAPIMovieResponse)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        }

        let actualResult = r.uc.execute(page: 1)

        waitForValue(of: actualResult, value: APIMoviesResponse.fakeAPIMovieResponse)
    }

    func testFetchMoviesFailed() {
        let r = arrange()

        let exp = expectation(description: "Fails")

        r.repoMock.stub.fetchPopularMovies = {
            Fail(error: RequestError.invalidResponse).eraseToAnyPublisher()
        }

        _ = r.uc.execute(page: 1).sink { completion in
            guard case .failure(let error) = completion else { return }
            XCTAssertEqual(error, RequestError.invalidResponse)
            exp.fulfill()
        } receiveValue: { _ in
            XCTFail("Expected to fail")
        }

        waitForExpectations(timeout: 2)
    }
}
