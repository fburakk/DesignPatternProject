//
//  FetchProducts.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// The FetchProducts class conforms to the ProductOperationStrategy protocol.
// It implements the logic to fetch all products from the local database (CoreData).
class FetchProducts: ProductOperationStrategy {
    
    // Reference to CoreDataManager for database operations
    private let coreDataManager: CoreDataManager

    // Initializer
    init(coreDataManager: CoreDataManager = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }

    // Executes the fetch operation to retrieve all products from the database
    // Uses a completion handler to return the result
    func execute(completion: (Result<Any, Error>) -> Void) {
        // Fetches all products of type 'Product' from CoreData
        let products = coreDataManager.fetch(type: Product.self)
        
        // Checks if the fetched products list is empty
        if products.isEmpty {
            print("No products found.")
        }
        // Returns the fetched products through the completion handler
        completion(.success(products))
    }
}
