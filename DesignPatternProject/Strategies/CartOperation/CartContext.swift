//
//  CartContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

// The CartContext class is part of the Strategy design pattern.
// It allows flexible execution of different cart-related operations by swapping strategies at runtime.
class CartContext {
    // Stores the current strategy to handle cart operations
    private var strategy: CartOperationStrategy

    // Initializes the context with a specific strategy
    // `strategy` is the operation handler, such as "Add to Cart" or "Remove from Cart"
    init(strategy: CartOperationStrategy) {
        self.strategy = strategy
    }

    // Method to change the current strategy at runtime
    // This allows switching between different operations dynamically
    func setStrategy(_ strategy: CartOperationStrategy) {
        self.strategy = strategy
    }

    // Executes the current strategy's logic
    // Accepts a completion handler to notify success or failure of the operation
    func executeStrategy(completion: (Result<Any, Error>) -> Void) {
        strategy.execute(completion: completion)
    }
}
