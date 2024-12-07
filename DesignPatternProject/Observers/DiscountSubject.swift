//
//  DiscountObserver.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 26.11.2024.
//

import Foundation

// Observers will implement this protocol to receive updates
protocol PDiscountObserver: AnyObject {
    func update(productId: String, discount: Double)
}

// The Subject will manage and notify observers about updates
protocol PDiscountSubject {
    // Adds an observer with a handler for discount updates
    func addObserver(_ observer: AnyObject, handler: @escaping DiscountSubject.DiscountUpdateHandler)
    
    // Removes a specific observer
    func removeObserver(_ observer: AnyObject)
    
    // Notifies all registered observers of a discount update
    func notifyObservers(for productId: String, discount: Double, completion: (() -> Void)?)
}

// It manages a list of observers and notifies them of updates
class DiscountSubject: PDiscountSubject {
    // Singleton instance to ensure only one DiscountSubject exists
    static let shared = DiscountSubject()

    // Private initializer to prevent external instantiation
    private init() {}

    // Type alias for the discount update handler
    typealias DiscountUpdateHandler = (_ productId: String, _ discount: Double) -> Void

    // Dictionary to store observers and their associated update handlers
    private var observers: [ObjectIdentifier: DiscountUpdateHandler] = [:]

    // Adds a new observer with a handler for discount updates
    func addObserver(_ observer: AnyObject, handler: @escaping DiscountUpdateHandler) {
        let id = ObjectIdentifier(observer) // Create a unique identifier for the observer
        observers[id] = handler // Store the observer and handler
    }

    // Removes an observer from the list
    func removeObserver(_ observer: AnyObject) {
        let id = ObjectIdentifier(observer) // Get the identifier for the observer
        observers.removeValue(forKey: id) // Remove the observer from the dictionary
    }

    // Notifies all observers of a discount update
    func notifyObservers(for productId: String, discount: Double, completion: (() -> Void)? = nil) {
        for handler in observers.values {
            handler(productId, discount) // Call each observer's handler
        }
        completion?() // Execute the completion handler if provided
    }
}

// It listens for updates from the DiscountSubject
class DiscountObserver: PDiscountObserver {
    // Handles the discount update notification
    func update(productId: String, discount: Double) {
        print("Product \(productId) has a new discount: \(discount)%")
    }
}
