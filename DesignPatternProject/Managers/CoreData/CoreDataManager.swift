//
//  CoreDataManager.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// CoreDataManager provides reusable methods for adding, fetching, and deleting Core Data entities.
// It acts as a helper class to simplify database interactions.
class CoreDataManager {
    // The managed object context used for interacting with the Core Data stack
    private let context: NSManagedObjectContext

    // Initializes the CoreDataManager with a specific context
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    // Generic function to add a new object of a specific Core Data entity type
    func add<T: NSManagedObject>(type: T.Type, configure: (T) -> Void) {
        let entityName = String(describing: T.self) // Get the entity's name as a string
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {
            fatalError("Failed to create entity of type \(entityName)")
        }
        configure(entity) // Pass the entity to the configuration closure
        saveContext() // Persist the changes
    }

    // Generic function to fetch objects of a specific Core Data entity type
    func fetch<T: NSManagedObject>(
        type: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self)) // Create a fetch request for the entity
        fetchRequest.predicate = predicate // Apply the filter if provided
        fetchRequest.sortDescriptors = sortDescriptors // Apply sorting criteria if provided

        do {
            return try context.fetch(fetchRequest) // Execute the fetch request and return results
        } catch {
            print("Failed to fetch \(T.self): \(error)")
            return [] // Return an empty array if fetching fails
        }
    }

    // Generic function to delete a specific Core Data object
    func delete<T: NSManagedObject>(entity: T) {
        context.delete(entity)
        saveContext() // Persist the changes
    }

    // Saves the current context to persist changes in the Core Data stack
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save() // Save the changes
                print("Context saved successfully.")
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
