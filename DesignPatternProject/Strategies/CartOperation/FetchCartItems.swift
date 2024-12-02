//
//  FetchCartItems.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// Struct to hold combined details of CardItem and Product
struct CartItemWithDetails {
    let name: String
    let price: Double
    let quantity: Int32
    let id: String
    let shippingMethod: String
    let paymentMethod: String
}



class FetchCartItems: CartOperationStrategy {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }
    
    func execute(completion: (Result<Any, Error>) -> Void) {
        var result: [CartItemWithDetails] = []
        
        let cartItems = coreDataManager.fetch(type: CardItem.self)
        
        for item in cartItems {
            guard let productId = item.productId else {
                continue
            }

            let predicate = NSPredicate(format: "id == %@", productId)
            if let product = coreDataManager.fetch(type: Product.self, predicate: predicate).first {
                let cartItemDetail = CartItemWithDetails(
                    name: product.name ?? "Unknown",
                    price: product.price,
                    quantity: item.quantity,
                    id: item.productId ?? "0",
                    shippingMethod: item.shipping ?? "",
                    paymentMethod: item.payment ?? ""
                )
                result.append(cartItemDetail)
            }
        }
        completion(.success(result))
    }
}
