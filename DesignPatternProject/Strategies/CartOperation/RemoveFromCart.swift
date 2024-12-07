//
//  RemoveFromCart.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// The RemoveFromCart class implements the CartOperationStrategy protocol.
// It provides the functionality to remove a product from the cart stored in the database.
class RemoveFromCart: CartOperationStrategy {
    private let productId: String
    private let coreDataManager: CoreDataManager // Manages database operations

    // Initializer
    init(productId: String, coreDataManager: CoreDataManager = CoreDataManager()) {
        self.productId = productId
        self.coreDataManager = coreDataManager
    }

    // Executes the removal operation
    // Accepts a completion handler to notify whether the operation succeeded or failed
    func execute(completion: (Result<Any, Error>) -> Void) {
        // Create a filter to find the cart item with the given product ID
        let predicate = NSPredicate(format: "productId == %@", productId)

        // Fetch the cart item matching the filter
        guard let cartItem = coreDataManager.fetch(type: CardItem.self, predicate: predicate).first else {
            // If no matching cart item is found, return an error
            completion(.failure(NSError(domain: "RemoveFromCart", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cart item not found."])))
            return
        }

        // If found, delete the cart item from the database
        coreDataManager.delete(entity: cartItem)

        // Save the changes to persist the deletion
        coreDataManager.saveContext()

        // Notify success through the completion handler
        completion(.success(true))
    }
}
