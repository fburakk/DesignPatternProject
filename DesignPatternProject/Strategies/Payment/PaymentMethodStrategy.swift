//
//  PaymentMethodStrategy.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// The PaymentMethodStrategy protocol defines a blueprint for implementing payment methods.
// It is part of the Strategy design pattern, allowing different payment methods to follow the same structure.
protocol PaymentMethodStrategy {
    // Method to process a payment with a specified amount.
    // Returns a string indicating the result of the payment processing.
    func processPayment(amount: Double) -> String
}
