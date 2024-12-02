//
//  RemoveFromCart.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

class RemoveFromCart: CartOperationStrategy {
    private let productId: String
    private let coreDataManager: CoreDataManager

    init(productId: String, coreDataManager: CoreDataManager = CoreDataManager()) {
        self.productId = productId
        self.coreDataManager = coreDataManager
    }

    func execute(completion: (Result<Any, Error>) -> Void) {
        let predicate = NSPredicate(format: "productId == %@", productId)
        guard let cartItem = coreDataManager.fetch(type: CardItem.self, predicate: predicate).first else {
            completion(.failure(NSError(domain: "RemoveFromCart", code: 404, userInfo: [NSLocalizedDescriptionKey: "Cart item not found."])))
            return
        }

        coreDataManager.delete(entity: cartItem)
        coreDataManager.saveContext()
        completion(.success(true))
    }
}
