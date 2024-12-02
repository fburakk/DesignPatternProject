//
//  StandartShipping.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

class StandardShipping: ShippingMethodStrategy {
    func calculateShippingCost(for distance: Double) -> Double {
        return 5.0 + (0.5 * distance)
    }

    func getShippingDescription() -> String {
        return "Standard Shipping"
    }
}
