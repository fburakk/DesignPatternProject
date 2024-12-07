//
//  CreditCart.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// The CreditCardPayment class conforms to the PaymentMethodStrategy protocol.
// It implements the logic for processing payments via credit card.
class CreditCardPayment: PaymentMethodStrategy {
    // Method to process a payment of the given amount using a credit card
    func processPayment(amount: Double) -> String {
        return "Payment of $\(amount) processed via Credit Card."
    }
}
