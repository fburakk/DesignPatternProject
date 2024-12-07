//
//  SortByPriceLowToHigh.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

// The SortByPriceLowToHigh class conforms to the SortStrategy protocol.
// It implements the logic for sorting products by price in ascending order (low to high).
class SortByPriceLowToHigh: SortStrategy {
    
    // Sorts an array of Product objects by price in ascending order.
    func sort(_ products: [Product]) -> [Product] {
        // Uses the Swift standard library's `sorted` method to sort the products
        return products.sorted { $0.price < $1.price }
    }
}
