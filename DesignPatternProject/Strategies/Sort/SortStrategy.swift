//
//  SortStrategy.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 27.11.2024.
//

import Foundation

protocol SortStrategy {
    func sort(_ products: [Product]) -> [Product]
}
