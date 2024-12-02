//
//  PaymentContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 1.12.2024.
//

import Foundation

class PaymentContext {
    private var strategy: PaymentMethodStrategy

    init(strategy: PaymentMethodStrategy) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: PaymentMethodStrategy) {
        self.strategy = strategy
    }

    func processPayment(amount: Double) -> String {
        return strategy.processPayment(amount: amount)
    }
}
