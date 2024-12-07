//
//  SortAlphabetically.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

// The SortAlphabetically class conforms to the SortStrategy protocol.
// It implements the logic for sorting products alphabetically by name in ascending order (A-Z).
class SortAlphabetically: SortStrategy {

    // Sorts an array of Product objects alphabetically by their name.
    func sort(_ products: [Product]) -> [Product] {
        // Uses the Swift standard library's `sorted` method to sort the products
        // The closure compares the names of two products in a case-insensitive manner.
        return products.sorted {
            ($0.name ?? "").localizedCaseInsensitiveCompare($1.name ?? "") == .orderedAscending
        }
    }
}
