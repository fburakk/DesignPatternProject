//
//  ApplePay.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

class ApplePayPayment: PaymentMethodStrategy {
    func processPayment(amount: Double) -> String {
        return "Payment of $\(amount)  processed via Apple Pay."
    }
}
