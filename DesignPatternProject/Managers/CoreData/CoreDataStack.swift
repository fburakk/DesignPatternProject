//
//  CoreDataStack.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// CoreDataStack is responsible for managing the Core Data stack.
// It initializes the database, provides a context for performing operations,
// and ensures changes are saved. It uses the Singleton pattern to ensure there's only one instance
// managing Core Data throughout the app.
class CoreDataStack {
    // Shared singleton instance of CoreDataStack
    static let shared = CoreDataStack()
    
    // Private initializer to prevent creating multiple instances of CoreDataStack
    private init() {}
    
    // Persistent Container manages the Core Data stack.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DesignPatternProject")
        // Load the persistent store (SQLite database)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Provides the main thread context for database interactions.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Saves changes in the context to the persistent store (database).
    func saveContext() {
        // Check if there are unsaved changes in the context
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully.")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
