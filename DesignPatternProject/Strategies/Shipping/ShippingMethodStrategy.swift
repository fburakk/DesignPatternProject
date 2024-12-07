//
//  ShippingMethodStrategy.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// The ShippingMethodStrategy protocol defines the structure for implementing different shipping methods.
protocol ShippingMethodStrategy {
    // Method to calculate the shipping cost based on the given distance.
    func calculateShippingCost(for distance: Double) -> Double

    // Method to provide a description of the shipping method.
    func getShippingDescription() -> String
}
