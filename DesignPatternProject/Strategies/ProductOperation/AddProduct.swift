//
//  AddProduct.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData
import UIKit

class AddProduct: ProductOperationStrategy {

    private let id: String
    private let name: String
    private let price: Double
    private let image: UIImage?
    private let coreDataManager: CoreDataManager

    init(id: String? = nil,
         name: String = "",
         price: Double = 0,
         image: UIImage? = nil,
         coreDataManager: CoreDataManager = CoreDataManager()) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.price = price
        self.image = image
        self.coreDataManager = coreDataManager
    }

    func execute(completion: (Result<Any, Error>) -> Void) {
        // Check if a product with the same ID exists
        let predicate = NSPredicate(format: "id == %@", id)
        let existingProducts = coreDataManager.fetch(type: Product.self, predicate: predicate)

        if !existingProducts.isEmpty {
            let error = NSError(domain: "AddProduct", code: 409, userInfo: [NSLocalizedDescriptionKey: "Product with ID \(id) already exists."])
            completion(.failure(error))
            return
        }

        // Add a new product
        coreDataManager.add(type: Product.self) { product in
            product.id = self.id
            product.name = self.name
            product.price = self.price
            product.imageData = self.image?.jpegData(compressionQuality: 0.8)
        }
        coreDataManager.saveContext()
        print("Product \(name) added successfully with ID \(id).")
        completion(.success(true))
    }
}
