//
//  CoreDataManager.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// CoreDataManager provides reusable methods for adding, fetching, and deleting Core Data entities.
class CoreDataManager {
    private let context: NSManagedObjectContext

    // Initialize with a specific context (default is CoreDataStack's context)
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    // Generic function to add a new object of type T
    func add<T: NSManagedObject>(type: T.Type, configure: (T) -> Void) {
        let entityName = String(describing: T.self)
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {
            fatalError("Failed to create entity of type \(entityName)")
        }
        configure(entity)
        saveContext()
    }

    // Generic function to fetch objects of type T with optional filtering and sorting
    func fetch<T: NSManagedObject>(
        type: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch \(T.self): \(error)")
            return []
        }
    }

    // Generic function to delete a specific object
    func delete<T: NSManagedObject>(entity: T) {
        context.delete(entity)
        saveContext()
    }

    // Save the current context to persist changes
     func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully.")
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
