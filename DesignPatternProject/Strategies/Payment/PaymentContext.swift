//
//  PaymentContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// The PaymentContext class is part of the Strategy design pattern.
// It acts as a context for selecting and executing different payment strategies at runtime.
class PaymentContext {
    // Stores the currently selected payment strategy
    private var strategy: PaymentMethodStrategy

    // Initializes the PaymentContext with a specific payment strategy
    init(strategy: PaymentMethodStrategy) {
        self.strategy = strategy
    }

    // Allows changing the payment strategy dynamically at runtime
    func setStrategy(_ strategy: PaymentMethodStrategy) {
        self.strategy = strategy
    }

    // Processes the payment using the current strategy
    // Takes the payment amount as input and returns a confirmation message
    func processPayment(amount: Double) -> String {
        return strategy.processPayment(amount: amount)
    }
}
