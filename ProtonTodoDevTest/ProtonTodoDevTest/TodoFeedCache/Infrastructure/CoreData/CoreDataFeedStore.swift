//
//  CoreDataStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import CoreData

public final class CoreDataFeedStore {
    // MARK: - Properties
    public static let storeURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appending(path: "todo-feed-store.sqlite")
    
    private static let modelName: String = "TodoFeedStore"
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
    /// Executes a throwing action on the background context and returns a result asynchronously.
    func performAsync<T>(_ action: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = self.context
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let result = try action(context) // Perform the action on the context
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
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
