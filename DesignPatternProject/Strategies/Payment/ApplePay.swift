//
//  ApplePay.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

// The ApplePayPayment class conforms to the PaymentMethodStrategy protocol.
// It provides an implementation for processing payments via Apple Pay.
class ApplePayPayment: PaymentMethodStrategy {
    // Processes a payment with the given amount using Apple Pay
    func processPayment(amount: Double) -> String {
        return "Payment of $\(amount) processed via Apple Pay."
    }
}
