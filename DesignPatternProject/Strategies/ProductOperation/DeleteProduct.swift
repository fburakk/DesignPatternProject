//
//  DeleteProduct.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

class DeleteProduct: ProductOperationStrategy {

    private let id: String
    private let coreDataManager: CoreDataManager

    init(id: String, coreDataManager: CoreDataManager = CoreDataManager()) {
        self.id = id
        self.coreDataManager = coreDataManager
    }

    func execute(completion: (Result<Any, Error>) -> Void) {
        // Fetch the product with the given ID
        let predicate = NSPredicate(format: "id == %@", id)
        guard let product = coreDataManager.fetch(type: Product.self, predicate: predicate).first else {
            let error = NSError(domain: "DeleteProduct", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found."])
            completion(.failure(error))
            return
        }

        // Delete the product
        coreDataManager.delete(entity: product)
        coreDataManager.saveContext()
        print("Product \(product.name ?? "Unknown") deleted successfully.")
        completion(.success(true))
    }
}
