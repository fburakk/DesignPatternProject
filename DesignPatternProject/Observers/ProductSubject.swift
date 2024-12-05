//
//  ProductObserver.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 26.11.2024.
//

import Foundation

// MARK: - Why Singleton?

/**
 The Singleton pattern was chosen for `ProductObserver` because:

 1. **Centralized Notification Management**:
    - Ensures a single source of truth for all product-related notifications.
    - All components of the app (e.g., `UploadProductViewController` and `ProductsViewController`)
      can rely on the same instance to stay updated.

 2. **Global Accessibility**:
    - Provides a globally accessible instance without requiring explicit dependency injection or passing references.

 3. **State Preservation**:
    - Maintains a consistent list of observers and ensures no redundant or missing updates during the app's lifecycle.

 4. **Resource Efficiency**:
    - Avoids creating multiple instances, which could lead to inconsistencies or unnecessary resource usage.

 5. **Decoupling**:
    - Allows components like `UploadProductViewController` to notify changes without directly referencing
      `ProductsViewController` or other observers. This promotes modularity and scalability.
*/




protocol PProductObserver: AnyObject {
    func update(products: [Product])
}


protocol PProductSubject {
    func addObserver(_ observer: PProductObserver)
    func removeObserver(_ observer: PProductObserver)
    func notifyObservers(with products: [Product])
}


/// A singleton class that manages observers for product updates.
/// This class is responsible for notifying registered observers when product-related changes occur,
/// such as adding, updating, or deleting products.
class ProductSubject {
    
    // MARK: - Singleton Instance

    /// The shared singleton instance of `ProductObserver`.
    static let shared = ProductSubject()

    // Private initializer to ensure only one instance is created.
    private init() {}

    // MARK: - Properties

    /// A dictionary of observer IDs and their associated update handlers.
    /// Key: A unique `UUID` representing the observer.
    /// Value: A closure that executes when product updates occur.
    typealias ProductUpdateHandler = ([Product]) -> Void
    private var observers: [UUID: ProductUpdateHandler] = [:]

    // MARK: - Public Methods

    /// Adds an observer for product updates.
    ///
    /// - Parameters:
    ///   - observer: The object registering for updates.
    ///   - handler: A closure that executes when products are updated.
    /// - Returns: A unique `UUID` that can be used to remove the observer later.
    func addObserver(_ observer: AnyObject, handler: @escaping ProductUpdateHandler) -> UUID {
        let id = UUID()
        observers[id] = handler
        return id
    }

    /// Removes an observer using its unique `UUID`.
    ///
    /// - Parameter id: The `UUID` of the observer to be removed.
    func removeObserver(with id: UUID) {
        observers.removeValue(forKey: id)
    }

    /// Notifies all registered observers of product updates.
    ///
    /// - Parameter products: The updated list of products.
    func notifyObservers(with products: [Product]) {
        for handler in observers.values {
            handler(products)
        }
    }
}
