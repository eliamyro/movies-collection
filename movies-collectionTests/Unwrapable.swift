//
//  Unwrapable.swift
//  movies-collectionTests
//
//  Created by Elias Myronidis on 19/5/23.
//

import Foundation
import XCTest

@propertyWrapper
public struct Unwrapable<Value> {
    private(set) var value: Value?

    public var wrappedValue: Value? {
        get { value }
        set { value = newValue }
    }

    public init() {}

    public func safeValue(
        file: StaticString = #file,
        line: UInt = #line,
        function: StaticString = #function
    ) -> Value! {
        guard let someValue = value else {
            XCTFailNoReturn("\(function) function with signature \(Value.self) called but not stubbed before.",
                            file: file)
        }

        return someValue
    }

    func XCTFailNoReturn(_ message: String = "", file: StaticString = #file, line: UInt = #line) -> Never {
        XCTFail(message, file: file, line: line)

        fatalError("Failed")
    }

    public var projectedValue: Unwrapable<Value> { return self }
}
