//
//  ShippingContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// It acts as a context for selecting and executing different shipping strategies dynamically.
class ShippingContext {
    // Holds the current shipping method strategy
    private var strategy: ShippingMethodStrategy

    // Initializer
    init(strategy: ShippingMethodStrategy) {
        self.strategy = strategy
    }

    // Allows changing the shipping strategy dynamically at runtime
    func setStrategy(_ strategy: ShippingMethodStrategy) {
        self.strategy = strategy
    }

    // Calculates the shipping cost using the current strategy
    func calculateCost(for distance: Double) -> Double {
        return strategy.calculateShippingCost(for: distance)
    }

    // Retrieves the description of the current shipping method
    func getDescription() -> String {
        return strategy.getShippingDescription()
    }
}
