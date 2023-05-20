//
//  DeleteFavoriteMediaFromDBUCMock.swift
//  movies-collectionTests
//
//  Created by Elias Myronidis on 19/5/23.
//

import Combine
import Foundation
@testable import movies_collection

class DeleteFavoriteMediaFromDBUCMock: DeleteFavoriteMediaFromDbUC {
    public let stub = Stub()

    public init() {}

    public class Stub {
        @Unwrapable public var execute: (() -> AnyPublisher<Bool, Never>)?
    }

    func execute(id: Int) -> AnyPublisher<Bool, Never> {
        return stub.$execute.safeValue()()
    }
}
