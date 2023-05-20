//
//  FetchMediaUCMock.swift
//  movies-collectionTests
//
//  Created by Elias Myronidis on 19/5/23.
//

import Combine
import Foundation
@testable import movies_collection

class FetchMediaUCMock: FetchMediaUC {
    public let stub = Stub()

    public init() {}

    public class Stub {
        @Unwrapable public var execute: (() -> AnyPublisher<APIMoviesResponse, RequestError>)?
    }

    func execute(query: String, page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        return stub.$execute.safeValue()()
    }
}
