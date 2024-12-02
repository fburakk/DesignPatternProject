//
//  CoreDataStack.swift
//  DesignPatternProject
//
//  Created by Burak Köse on 24.11.2024.
//

import CoreData

// CoreDataStack is responsible for managing the Core Data stack.
// This includes setting up the database, providing a context for performing operations,
// and saving changes. It uses the Singleton pattern to ensure there's only one instance
// managing Core Data throughout the app.
class CoreDataStack {
    // Shared singleton instance of CoreDataStack
    static let shared = CoreDataStack()

    // Private initializer to prevent creating multiple instances of CoreDataStack
    private init() {}

    // Persistent Container manages the Core Data stack
    // It handles:
    // - Loading the Core Data model file (DesignPatternProject.xcdatamodeld)
    // - Setting up the database file (SQLite store)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DesignPatternProject") // Replace with your Core Data model name
        // Load the persistent store (SQLite database)
        container.loadPersistentStores { _, error in
            // If there’s an error loading the database, the app will crash
            // and provide error details for debugging.
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // The context is used to interact with the database.
    // It is the main thread context, suitable for most UI-related operations.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Saves changes in the context to the persistent store (database).
    // This ensures that any new objects or modifications are persisted.
    func saveContext() {
        // Check if there are unsaved changes in the context
        if context.hasChanges {
            do {
                // Attempt to save the changes
                try context.save()
                print("Context saved successfully.")
            } catch {
                // If saving fails, log the error for debugging purposes
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
