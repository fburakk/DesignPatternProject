//
//  CartContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

class CartContext {
    private var strategy: CartOperationStrategy

    init(strategy: CartOperationStrategy) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: CartOperationStrategy) {
        self.strategy = strategy
    }

    func executeStrategy(completion: (Result<Any, Error>) -> Void) {
        strategy.execute(completion: completion)
    }
}
