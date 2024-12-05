//
//  DiscountObserver.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 26.11.2024.
//

import Foundation


protocol PDiscountObserver: AnyObject {
    
    func update(productId: String, discount: Double)
}


protocol PDiscountSubject {
    
    func addObserver(_ observer: PDiscountObserver)
    func removeObserver(_ observer: PDiscountObserver)
    func notifyObservers(for productId: String, discount: Double)
}


class DiscountSubject {
    static let shared = DiscountSubject()

    private init() {}

    typealias DiscountUpdateHandler = (_ productId: String, _ discount: Double) -> Void
    private var observers: [ObjectIdentifier: DiscountUpdateHandler] = [:]

    // Add an observer
    func addObserver(_ observer: AnyObject, handler: @escaping DiscountUpdateHandler) {
        let id = ObjectIdentifier(observer)
        observers[id] = handler
    }

    // Remove an observer
    func removeObserver(_ observer: AnyObject) {
        let id = ObjectIdentifier(observer)
        observers.removeValue(forKey: id)
    }

    // Notify all observers with productId and discount
    func notifyObservers(for productId: String, discount: Double) {
        for handler in observers.values {
            handler(productId, discount)
        }
    }
}



class ConcreteObserver: PDiscountObserver {
    
    func update(productId: String, discount: Double) {
        print("Product \(productId) has a new discount: \(discount)%")
    }
}
