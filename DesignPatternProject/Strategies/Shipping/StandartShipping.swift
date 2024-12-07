//
//  StandardShipping.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// The StandardShipping class conforms to the ShippingMethodStrategy protocol.
// It provides the logic for calculating costs and describing the "Standard Shipping" method.
class StandardShipping: ShippingMethodStrategy {
    
    // Calculates the shipping cost based on the distance.
    func calculateShippingCost(for distance: Double) -> Double {
        // Base cost is $5.0, and each unit of distance adds $0.5 to the cost.
        return 5.0 + (0.5 * distance)
    }

    // Provides a description of the "Standard Shipping" method.
    func getShippingDescription() -> String {
        return "Standard Shipping"
    }
}
