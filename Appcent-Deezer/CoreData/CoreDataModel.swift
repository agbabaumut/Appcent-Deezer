//
//  CoreDataModel.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Appcent_Deezer") // Replace with your data model name
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Failed to save Core Data context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

