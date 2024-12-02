//
//  PayPal.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

class PayPalPayment: PaymentMethodStrategy {
    func processPayment(amount: Double) -> String {
        return "Payment of $\(amount) processed via PayPal."
    }
}
