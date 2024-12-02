//
//  FetchProducts.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

class FetchProducts: ProductOperationStrategy {

    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }

    func execute(completion: (Result<Any, Error>) -> Void) {
        // Fetch all products
        let products = coreDataManager.fetch(type: Product.self)

        if products.isEmpty {
            print("No products found.")
        }

        completion(.success(products))
    }
}
