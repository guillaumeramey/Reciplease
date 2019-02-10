//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Guillaume Ramey on 08/02/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    func saveContext () -> Bool {
        let context = persistentContainer.viewContext

        do {
            try context.save()
        } catch {
            print(error)
            return false
        }
        return true
    }
}
