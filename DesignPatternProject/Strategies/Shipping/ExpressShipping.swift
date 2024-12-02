//
//  ExpressShipping.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

class ExpressShipping: ShippingMethodStrategy {
    func calculateShippingCost(for distance: Double) -> Double {
        return 10.0 + (1.0 * distance)
    }

    func getShippingDescription() -> String {
        return "Express Shipping"
    }
}
