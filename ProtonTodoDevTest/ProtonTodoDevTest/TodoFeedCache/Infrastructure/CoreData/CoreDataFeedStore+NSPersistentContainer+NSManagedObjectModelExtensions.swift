//
//  CoreData+NSPersistentContainer+NSManagedObjectModelExtensions.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    /// Simplifies the process of configuring and loading an NSPersistentContainer
    /// Creates a NSPersistentStoreDescription with the given url.
    /// Assigns it to the persistentStoreDescriptions array of the container.
    /// Attempts to load the store. If it fails, the error is thrown.
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        
        return container
    }
}

extension NSManagedObjectModel {
    /// Loads a NSManagedObjectModel from the app bundle
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
