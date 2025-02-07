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
        return cache.compactMap { $0.local }
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
        let managedCache = try ManagedCache.fetchOrCreateCache(in: context)
        
        let existingTaskIDs = try ManagedTodoItem.fetchExistingTodoIDs(in: context)
        
        // Filter new tasks (skip existing tasks)
        let newTasks = tasks.filter {
            !existingTaskIDs.contains($0.id)
        }
        
        // Insert only new tasks into the cache
        if !newTasks.isEmpty {
            try managedCache.updateCache(with: newTasks, in: context)
            try context.save()
            
            // Clear cached user info after saving new tasks
            ManagedTodoItem.clearUserInfo(in: context)
        }
    }
}

// MARK: - Updating Cache
extension ManagedCache {
    private func updateCache(
        with items: [LocalTodoItem],
        in context: NSManagedObjectContext
    ) throws {
        // Ensure cache is fetched or created
        let managedCache = try ManagedCache.fetchOrCreateCache(in: context)
        
        // Get current ordered tasks (avoiding duplicates)
        let existingTasks = feed.mutableCopy() as? NSMutableOrderedSet ?? NSMutableOrderedSet()
        
        // Create new tasks from the provided items
        let newTasks = ManagedTodoItem.createBatch(from: items, in: context, with: managedCache)
        
        // Add new tasks to the existing ordered set
        addItemsToCache(existingTasks, newItems: newTasks)
        
        // Safely update the cache feed - NSOrderedSet
        guard let updatedCache = existingTasks.copy() as? NSOrderedSet else {
            throw CoreDataFeedStoreError.missingManagedObjectContext
        }
        feed = updatedCache
        
        ManagedTodoItem.clearUserInfo(in: context)
    }
    
    private func addItemsToCache(_ existingTasks: NSMutableOrderedSet, newItems: [ManagedTodoItem]) {
        // Add new items to the existing set in order
        for newItem in newItems {
            existingTasks.add(newItem)
        }
    }
    
    static func update(_ item: LocalTodoItem, in context: NSManagedObjectContext) throws {
        guard let managedTodo = try ManagedTodoItem.first(with: item.imageURL, in: context) else {
            throw CoreDataFeedStoreError.todoNotFound
        }
        
        ManagedTodoItem.update(managedTodo, with: item)
        
        try context.save()
    }
}
