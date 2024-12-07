//
//  DeleteProduct.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// The DeleteProduct class conforms to the ProductOperationStrategy protocol.
// It provides functionality to delete a product from the local database (CoreData).
class DeleteProduct: ProductOperationStrategy {

    private let id: String
    // Reference to CoreDataManager for handling database operations
    private let coreDataManager: CoreDataManager

    // Initializer
    init(id: String, coreDataManager: CoreDataManager = CoreDataManager()) {
        self.id = id
        self.coreDataManager = coreDataManager
    }

    // Executes the deletion operation for the product with the specified ID
    // Uses a completion handler to notify the result of the operation
    func execute(completion: (Result<Any, Error>) -> Void) {
        // Creates a predicate to find the product by its unique ID
        let predicate = NSPredicate(format: "id == %@", id)
        
        // Fetches the product matching the predicate
        guard let product = coreDataManager.fetch(type: Product.self, predicate: predicate).first else {
            // If the product is not found, return an error through the completion handler
            let error = NSError(domain: "DeleteProduct", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found."])
            completion(.failure(error))
            return
        }
        
        // Deletes the fetched product entity from the database
        coreDataManager.delete(entity: product)
        // Saves the context to persist the changes
        coreDataManager.saveContext()
        
        print("Product \(product.name ?? "Unknown") deleted successfully.")
        // Notifies success through the completion handler
        completion(.success(true))
    }
}
