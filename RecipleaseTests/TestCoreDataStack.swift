//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Guillaume Ramey on 08/02/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation
import CoreData
@testable import Reciplease

class TestCoreDataStack: CoreDataStack {

    convenience init() {
        self.init(modelName: Constants.modelName)
    }

    override init(modelName: String) {
        super.init(modelName: modelName)

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } }
        persistentContainer = container
    }
}
