//
//  ProductContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

// The ProductContext class is part of the Strategy design pattern.
// It allows dynamic selection and execution of various product-related operations at runtime.
class ProductContext {
    // Stores the current product operation strategy
    private var strategy: any ProductOperationStrategy

    // Initializer
    init(strategy: any ProductOperationStrategy) {
        self.strategy = strategy
    }

    // Allows changing the current product operation strategy dynamically
    func setStrategy(_ strategy: any ProductOperationStrategy) {
        self.strategy = strategy
    }
    
    // Executes the current strategy's operation
    // Uses a completion handler to notify the result (success or failure)
    func executeStrategy(completion: (Result<Any, Error>) -> Void) {
        strategy.execute(completion: completion)
    }
}
