//
//  CartOperationStrategy.swift
//  DesignPatternProject
//

import Foundation

/// Protocol for cart operations using a uniform result type.
protocol CartOperationStrategy {
    func execute(completion: (Result<Any, Error>) -> Void)
}
