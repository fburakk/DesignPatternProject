//
//  ProductOperationStrategy.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import Foundation

// The ProductOperationStrategy protocol defines a blueprint for product-related operations.
// It is part of the Strategy design pattern, allowing various operations on products
protocol ProductOperationStrategy {
    // Method to execute the product operation.
    // The completion handler provides the result of the operation:
    func execute(completion: (Result<Any, Error>) -> Void)
}
