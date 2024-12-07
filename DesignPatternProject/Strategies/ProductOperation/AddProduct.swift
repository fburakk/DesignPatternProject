//
//  AddProduct.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData
import UIKit

// The AddProduct class conforms to the ProductOperationStrategy protocol.
// It handles the operation of adding a new product to the local database (CoreData).
class AddProduct: ProductOperationStrategy {

    // Properties to store product details
    private let id: String
    private let name: String
    private let price: Double
    private let image: UIImage?
    private let coreDataManager: CoreDataManager // Manages interactions with CoreData

    // Initializer
    // Optional parameters have default values for convenience
    init(id: String? = nil,
         name: String = "",
         price: Double = 0,
         image: UIImage? = nil,
         coreDataManager: CoreDataManager = CoreDataManager()) {
        self.id = id ?? UUID().uuidString // Generate a unique ID if not provided
        self.name = name
        self.price = price
        self.image = image
        self.coreDataManager = coreDataManager
    }

    // Executes the add product operation
    // Uses a completion handler to return the result (success or failure)
    func execute(completion: (Result<Any, Error>) -> Void) {
        // Create a predicate to check if a product with the same ID already exists
        let predicate = NSPredicate(format: "id == %@", id)
        let existingProducts = coreDataManager.fetch(type: Product.self, predicate: predicate)

        // If a product with the same ID exists, return an error
        if !existingProducts.isEmpty {
            let error = NSError(domain: "AddProduct", code: 409, userInfo: [NSLocalizedDescriptionKey: "Product with ID \(id) already exists."])
            completion(.failure(error))
            return
        }

        // Add a new product to the database
        coreDataManager.add(type: Product.self) { product in
            product.id = self.id
            product.name = self.name
            product.price = self.price
            product.imageData = self.image?.jpegData(compressionQuality: 0.8) // Convert and store the image as JPEG data
        }

        // Save the changes to persist the new product in the database
        coreDataManager.saveContext()

        // Log the success and notify via the completion handler
        print("Product \(name) added successfully with ID \(id).")
        completion(.success(true))
    }
}
