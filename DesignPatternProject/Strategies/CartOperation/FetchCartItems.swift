//
//  FetchCartItems.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// The FetchCartItems class implements the CartOperationStrategy protocol,
// enabling the fetching of cart items along with their product details.
class FetchCartItems: CartOperationStrategy {
    // Reference to CoreDataManager to handle database operations.
    private let coreDataManager: CoreDataManager
    
    // Initializes the FetchCartItems instance with a CoreDataManager dependency.
    init(coreDataManager: CoreDataManager = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }
    
    // Executes the fetch operation to retrieve cart items and their associated product details.
    // Uses a completion handler to return the result.
    func execute(completion: (Result<Any, Error>) -> Void) {
        var result: [CartItemWithDetails] = [] // Stores the final list of detailed cart items
        
        // Fetch all cart items from the database
        let cartItems = coreDataManager.fetch(type: CardItem.self)
        
        // Iterate through each cart item
        for item in cartItems {
            guard let productId = item.productId else {
                // Skip cart items without a valid product ID
                continue
            }
            
            // Use the product ID to fetch the associated product details
            let predicate = NSPredicate(format: "id == %@", productId)
            if let product = coreDataManager.fetch(type: Product.self, predicate: predicate).first {
                // Combine cart item details with product details into a CartItemWithDetails struct
                let cartItemDetail = CartItemWithDetails(
                    name: product.name ?? "Unknown",
                    price: product.price,
                    quantity: item.quantity,
                    id: item.productId ?? "0",
                    shippingMethod: item.shipping ?? "",
                    paymentMethod: item.payment ?? ""
                )
                result.append(cartItemDetail) // Add the detailed cart item to the results
            }
        }
        // Return the results using the completion handler
        completion(.success(result))
    }
}

// Struct to hold combined details of a cart item and its related product information.
struct CartItemWithDetails {
    let name: String
    let price: Double
    let quantity: Int32
    let id: String
    let shippingMethod: String
    let paymentMethod: String
}
