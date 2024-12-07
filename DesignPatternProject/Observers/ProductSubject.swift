//
//  ProductObserver.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 26.11.2024.
//

import Foundation

// Observers will implement this protocol to receive updates about products
protocol PProductObserver: AnyObject {
    func update(products: [Product])
}

// The Subject will manage and notify observers about product updates
protocol PProductSubject {
    // Adds an observer with a handler for product updates and returns a unique ID
    func addObserver(_ observer: AnyObject, handler: @escaping ProductSubject.ProductUpdateHandler) -> UUID
    
    // Removes an observer using its unique ID
    func removeObserver(with id: UUID)
    
    // Notifies all registered observers with the latest list of products
    func notifyObservers(with products: [Product])
}

// It manages a list of observers and notifies them of updates to the products
class ProductSubject: PProductSubject {
    
    // Singleton instance to ensure only one ProductSubject exists
    static let shared = ProductSubject()
    
    // Private initializer to prevent external instantiation
    private init() {}
    
    // Type alias for the product update handler
    typealias ProductUpdateHandler = ([Product]) -> Void
    
    // Dictionary to store observers and their associated update handlers, identified by UUIDs
    private var observers: [UUID: ProductUpdateHandler] = [:]
    
    // Adds a new observer with a handler for product updates
    // Returns a UUID to uniquely identify the observer
    func addObserver(_ observer: AnyObject, handler: @escaping ProductUpdateHandler) -> UUID {
        let id = UUID() // Generate a unique identifier for the observer
        observers[id] = handler // Store the observer's handler in the dictionary
        return id
    }
    
    // Removes an observer from the list using its unique ID
    func removeObserver(with id: UUID) {
        observers.removeValue(forKey: id) // Remove the observer from the dictionary
    }
    
    // Notifies all observers with the updated list of products
    func notifyObservers(with products: [Product]) {
        for handler in observers.values {
            handler(products) // Call each observer's handler with the updated products
        }
    }
}

// It listens for updates from the ProductSubject
class ProductObserver: PProductObserver {
    // Handles the product update notification
    func update(products: [Product]) {
        print("Received product updates:")
        for product in products {
            print("- \(product.name ?? "")")
        }
    }
}
