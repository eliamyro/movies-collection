//
//  FetchMediaUCTests.swift
//  movies-collectionTests
//
//  Created by Elias Myronidis on 20/5/23.
//

import Combine
import XCTest
@testable import movies_collection

// swiftlint:disable identifier_name
final class FetchMediaUCTests: XCTestCase {

    private func arrange() -> (uc: FetchMediaUC,
                               moviesRepoMock: MoviesRepoMock) {
        let moviesRepoMock = MoviesRepoMock()

        DInjection.shared = DInjection(empty: true)
            .register(MoviesRepo.self) { moviesRepoMock }

        return (FetchMediaUCImp(), moviesRepoMock)
    }

    func testFetchMediaSuccess() {
        let r = arrange()

        r.moviesRepoMock.stub.fetchMedia = {
            Just(APIMoviesResponse.fakeAPIMovieResponse)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        }

        let actualResult = r.uc.execute(query: "Dummy", page: 1)

        waitForValue(of: actualResult, value: APIMoviesResponse.fakeAPIMovieResponse)

    }
}
