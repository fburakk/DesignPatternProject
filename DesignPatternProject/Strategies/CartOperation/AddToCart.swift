//
//  AddToCart.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

class AddToCart: CartOperationStrategy {
    private let productId: String
    private let shippingMethod: String
    private let paymentMethod: String
    private let coreDataManager: CoreDataManager

    init(productId: String = "",
         shippingMethod: String = "",
         paymentMethod: String = "",
         coreDataManager: CoreDataManager = CoreDataManager()) {
        self.productId = productId
        self.shippingMethod = shippingMethod
        self.paymentMethod = paymentMethod
        self.coreDataManager = coreDataManager
    }

    func execute(completion: (Result<Any, Error>) -> Void) {
        let productPredicate = NSPredicate(format: "id == %@", productId)
        guard let product = coreDataManager.fetch(type: Product.self, predicate: productPredicate).first else {
            completion(.failure(NSError(domain: "AddToCart", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found."])))
            return
        }

        let cartPredicate = NSPredicate(format: "productId == %@", productId)
        if let existingCartItem = coreDataManager.fetch(type: CardItem.self, predicate: cartPredicate).first {
            existingCartItem.quantity += 1
            coreDataManager.saveContext()
            completion(.success(true))
        } else {
            coreDataManager.add(type: CardItem.self) { cartItem in
                cartItem.productId = productId
                cartItem.quantity = 1
                cartItem.shipping = shippingMethod
                cartItem.payment = paymentMethod
            }
            coreDataManager.saveContext()
            completion(.success(true))
        }
    }
}
