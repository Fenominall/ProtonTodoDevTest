//
//  CoreDataStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import CoreData

final class CoreDataFeedStore {
    // MARK: - Properties
    static let storeURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appending(path: "")
    
    private static let modelName: String = ""
    private static let model = NSManagedObjectModel
        .with(
            name: modelName,
            in: Bundle(for: CoreDataFeedStore.self)
        )
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    //MARK: - Initialization
    public init(storeURL: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw StoreError.modelNotFound
        }
        do {
            container = try NSPersistentContainer.load(
                name: CoreDataFeedStore.modelName,
                model: model,
                url: storeURL
            )
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    /// The action is executed on the background context, preventing any blocking of the main thread during data operations.
    func performAsync(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    // MARK: - Deinitialization
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
