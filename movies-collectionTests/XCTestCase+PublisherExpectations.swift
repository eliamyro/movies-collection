//
//  XCTestCase+PublisherExpectations.swift
//  movies-collectionTests
//
//  Created by Elias Myronidis on 19/5/23.
//

import Combine
import XCTest

extension XCTestCase {
    func waitForValue<V, F>(of publisher: some Publisher<V, F>,
                            timeout: TimeInterval = 2,
                            file: StaticString = #file,
                            line: UInt = #line,
                            value: V) where V: Equatable {
        let exp = expectation(description: "Waiting for value: \(value) failed")
        exp.assertForOverFulfill = false

        let cancellable = publisher
            .sink(receiveCompletion: { _ in },
                  receiveValue: { receiveValue in
                exp.expectationDescription += " received: \(receiveValue)"
                if receiveValue == value {
                    exp.fulfill()
                }
            })

        waitForExpectation(exp: exp, timeout: timeout, file: file, line: line)

        XCTAssertNotNil(cancellable, file: file, line: line)
        cancellable.cancel()
    }

    func waitForExpectation(exp: XCTestExpectation,
                            timeout: TimeInterval = 2,
                            enforceOrder: Bool = false,
                            file: StaticString = #file,
                            line: UInt = #line) {
        let result = XCTWaiter.wait(for: [exp], timeout: timeout, enforceOrder: enforceOrder)
        switch result {
        case .timedOut:
            XCTFail(exp.expectationDescription, file: file, line: line)
        default:
            break
        }
    }
}
