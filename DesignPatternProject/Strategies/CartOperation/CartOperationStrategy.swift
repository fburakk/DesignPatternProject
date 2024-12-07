//
//  CartOperationStrategy.swift
//  DesignPatternProject
//

import Foundation

// The CartOperationStrategy protocol defines a blueprint for all cart-related operations.
// It is part of the Strategy design pattern and ensures that any operation (e.g., add, remove) conforms to this structure.
protocol CartOperationStrategy {
    // The `execute` method performs the specific cart operation.
    // It takes a completion handler as a parameter to notify the result of the operation:
    func execute(completion: (Result<Any, Error>) -> Void)
}
