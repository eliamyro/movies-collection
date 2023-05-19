//
//  DependencyContainer.swift
//  movies-collection
//
//  Created by Elias Myronidis on 13/5/23.
//

import Foundation

class DependencyContainer {
    public init() {}

    private var factories: [String: () -> Any] = [:]

    @discardableResult func register<T>(_ type: T.Type, _ factory: @escaping () -> T) -> Self {
        print("Type: \(type.self)")
        factories[String(describing: type.self)] = factory
        return self
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let name = String(describing: type.self)
        print("Factory name: \(name)")

        guard let factory = factories[name]?() as? T else {
            fatalError("Dependency \(T.self) not resolved")
        }

        return factory
    }
}
