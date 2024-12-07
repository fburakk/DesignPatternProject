//
//  PayPal.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// The PayPalPayment class conforms to the PaymentMethodStrategy protocol.
// It implements the logic for processing payments via PayPal.
class PayPalPayment: PaymentMethodStrategy {
    // Method to process a payment of the given amount using PayPal
    func processPayment(amount: Double) -> String {
        return "Payment of $\(amount) processed via PayPal."
    }
}
