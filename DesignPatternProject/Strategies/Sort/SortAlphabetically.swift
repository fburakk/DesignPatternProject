//
//  SortAlphabetically.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

class SortAlphabetically: SortStrategy {
    func sort(_ products: [Product]) -> [Product] {
        return products.sorted { ($0.name ?? "").localizedCaseInsensitiveCompare($1.name ?? "") == .orderedAscending }
    }
}
