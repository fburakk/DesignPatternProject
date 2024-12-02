//
//  ProductOperationStrategy.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//
import Foundation

protocol ProductOperationStrategy {
    func execute(completion: (Result<Any, Error>) -> Void)
}
