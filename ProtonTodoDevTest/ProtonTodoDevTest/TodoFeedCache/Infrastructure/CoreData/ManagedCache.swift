//
//  ManagedCache+CoreDataClass.swift
//
//
//  Created by Fenominall on 2/7/25.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
final class ManagedCache: NSManagedObject {
    @NSManaged var feed: NSOrderedSet
}

// MARK: - Local Representation
extension ManagedCache {
    var localFeed: [LocalTodoItem] {
        guard let cache = feed.array as? [ManagedTodoItem] else {
            return []
        }
        return cache.compactMap {
            return $0.local }
    }
}

// MARK: - Fetching Cache
extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        guard let entityName = entity().name else { return nil }
        let request = NSFetchRequest<ManagedCache>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    private static func fetchOrCreateCache(in context: NSManagedObjectContext) throws -> ManagedCache {
        guard let oldCache = try ManagedCache.find(in: context) else {
            let newCache = ManagedCache(context: context)
            try context.save()
            return newCache
        }
        return oldCache
    }
}

// MARK: - Inserting Cache
extension ManagedCache {
    static func insert(
        _ tasks: [LocalTodoItem],
        in context: NSManagedObjectContext
    ) throws {
        let managedCache = try fetchOrCreateCache(in: context)
        
        let existingTaskIDs = try ManagedTodoItem.fetchExistingTasksByID(in: context)
        
        var tasksToUpdate = [ManagedTodoItem: LocalTodoItem]()
        var newTasks = [LocalTodoItem]()
                
        for task in tasks {
            if let existingID = existingTaskIDs[task.id] {
                tasksToUpdate[existingID] = task
            } else {
                newTasks.append(task)
            }
        }
        
        for (managedTodo, localTodo) in tasksToUpdate {
            try ManagedTodoItem.update(
                managedTodo,
                with: localTodo,
                in: context
            )
        }
                
        if !newTasks.isEmpty {
            try managedCache.updateCache(with: newTasks, in: context)
        }
        try context.save()
        // Clear cached user info after saving new tasks
        ManagedTodoItem.clearUserInfo(in: context)
    }
}

// MARK: - Updating Cache
extension ManagedCache {
    private func updateCache(
        with items: [LocalTodoItem],
        in context: NSManagedObjectContext
    ) throws {
        let managedCache = try ManagedCache.fetchOrCreateCache(in: context)
        let existingTasksByID = try ManagedTodoItem.fetchExistingTasksByID(in: context)
        
        let newItems = items.filter { existingTasksByID[$0.id] == nil }
        let newTasks = try ManagedTodoItem.createBatch(from: newItems, in: context, with: managedCache)

        let existingtasks = feed.mutableCopy() as? NSMutableOrderedSet ?? NSMutableOrderedSet()
        addItemsToCache(existingtasks, newItems: newTasks)
        
        guard let updatedCache = existingtasks.copy() as? NSOrderedSet else {
            throw CoreDataFeedStoreError.missingManagedObjectContext
        }
        
        feed = updatedCache
    }
    
    private func addItemsToCache(_ existingTasks: NSMutableOrderedSet, newItems: [ManagedTodoItem]) {
        for newItem in newItems {
            existingTasks.add(newItem)
        }
    }
    
    static func update(_ item: LocalTodoItem, in context: NSManagedObjectContext) throws {
        guard let managedTodo = try ManagedTodoItem.first(with: item.imageURL, in: context) else {
            throw CoreDataFeedStoreError.todoNotFound
        }
        
        try ManagedTodoItem.update(managedTodo, with: item, in: context)
        
        try context.save()
    }
}
