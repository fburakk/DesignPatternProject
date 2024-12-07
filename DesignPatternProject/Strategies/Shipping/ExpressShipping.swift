//
//  ExpressShipping.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// The ExpressShipping class conforms to the ShippingMethodStrategy protocol.
// It provides the logic for calculating costs and describing the "Express Shipping" method.
class ExpressShipping: ShippingMethodStrategy {

    // Calculates the shipping cost based on the distance.
    func calculateShippingCost(for distance: Double) -> Double {
        // Base cost is $10.0, and each unit of distance adds $1.0 to the cost.
        return 10.0 + (1.0 * distance)
    }

    // Provides a description of the "Express Shipping" method.
    func getShippingDescription() -> String {
        return "Express Shipping"
    }
}
