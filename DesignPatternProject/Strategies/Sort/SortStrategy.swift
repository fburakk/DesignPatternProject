//
//  SortStrategy.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

// The SortStrategy protocol defines a blueprint for implementing different sorting algorithms.
// It is part of the Strategy design pattern, enabling dynamic selection of sorting methods.
protocol SortStrategy {
    // Method to sort an array of Product objects.
    func sort(_ products: [Product]) -> [Product]
}
