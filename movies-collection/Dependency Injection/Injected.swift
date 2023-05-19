//
//  Injected.swift
//  movies-collection
//
//  Created by Elias Myronidis on 13/5/23.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    private var value: T

    public var wrappedValue: T { value }

    init() {
        guard let value = DInjection.shared.resolve(T.self) else {
            fatalError("No dependency of this type is registered.")
        }

        self.value = value
    }
}
