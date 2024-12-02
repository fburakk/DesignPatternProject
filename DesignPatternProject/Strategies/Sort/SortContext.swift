//
//  SortContext.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

class SortContext {
    private var strategy: SortStrategy

    init(strategy: SortStrategy) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: SortStrategy) {
        self.strategy = strategy
    }

    func sortProducts(_ products: [Product]) -> [Product] {
        return strategy.sort(products)
    }
}
