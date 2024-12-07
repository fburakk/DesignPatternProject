//
//  AddToCart.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// The AddToCart class implements a strategy to handle the "add to cart" operation.
// It interacts with the local database (CoreData) to add or update cart items.
class AddToCart: CartOperationStrategy {
    // Variables to store product details and dependencies
    private let productId: String
    private let shippingMethod: String
    private let paymentMethod: String
    private let coreDataManager: CoreDataManager // Manages CoreData interactions

    // Initializer
    init(productId: String = "",
         shippingMethod: String = "",
         paymentMethod: String = "",
         coreDataManager: CoreDataManager = CoreDataManager()) {
        self.productId = productId
        self.shippingMethod = shippingMethod
        self.paymentMethod = paymentMethod
        self.coreDataManager = coreDataManager
    }

    // Function to execute the add-to-cart operation
    // Accepts a completion handler to report success or failure
    func execute(completion: (Result<Any, Error>) -> Void) {
        // Find the product in the database using the product ID
        let productPredicate = NSPredicate(format: "id == %@", productId)
        guard let product = coreDataManager.fetch(type: Product.self, predicate: productPredicate).first else {
            // If the product is not found, return an error
            completion(.failure(NSError(domain: "AddToCart", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found."])))
            return
        }

        // Check if the product is already in the cart
        let cartPredicate = NSPredicate(format: "productId == %@", productId)
        if let existingCartItem = coreDataManager.fetch(type: CardItem.self, predicate: cartPredicate).first {
            // If it exists, increase the quantity and save the changes
            existingCartItem.quantity += 1
            coreDataManager.saveContext()
            completion(.success(true))
        } else {
            // If it does not exist, create a new cart item and set its details
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
