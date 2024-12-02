//
//  ProductContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

/// Context for managing product operations dynamically
class ProductContext {
    private var strategy: any ProductOperationStrategy

    init(strategy: any ProductOperationStrategy) {
        self.strategy = strategy
    }

    /// Sets a new strategy dynamically
    func setStrategy(_ strategy: any ProductOperationStrategy) {
        self.strategy = strategy
    }

    /// Executes the current strategy
    func executeStrategy(completion: (Result<Any, Error>) -> Void) {
        strategy.execute(completion: completion)
    }
}
