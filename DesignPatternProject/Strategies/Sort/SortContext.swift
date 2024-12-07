//
//  SortContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

// The SortContext class is part of the Strategy design pattern.
// It acts as a context for selecting and executing different sorting strategies dynamically.
class SortContext {
    // Holds the current sorting strategy
    private var strategy: SortStrategy

    // Initializes the context with a specific sorting strategy
    init(strategy: SortStrategy) {
        self.strategy = strategy
    }

    // Dynamically updates the sorting strategy at runtime
    func setStrategy(_ strategy: SortStrategy) {
        self.strategy = strategy
    }

    // Sorts an array of Product objects using the current sorting strategy
    func sortProducts(_ products: [Product]) -> [Product] {
        return strategy.sort(products)
    }
}
