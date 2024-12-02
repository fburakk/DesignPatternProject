//
//  ShippingContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

class ShippingContext {
    private var strategy: ShippingMethodStrategy

    init(strategy: ShippingMethodStrategy) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: ShippingMethodStrategy) {
        self.strategy = strategy
    }

    func calculateCost(for distance: Double) -> Double {
        return strategy.calculateShippingCost(for: distance)
    }

    func getDescription() -> String {
        return strategy.getShippingDescription()
    }
}
