//
//  ShippingMethodStrategy.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation
protocol ShippingMethodStrategy {
    func calculateShippingCost(for distance: Double) -> Double
    func getShippingDescription() -> String
}
