//
//  ManagedTodoItem+CoreDataClass.swift
//
//
//  Created by Fenominall on 2/7/25.
//
//

import Foundation
import CoreData

@objc(ManagedTodoItem)
final class ManagedTodoItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: Data?
    @NSManaged var todoDescription: Data?
    @NSManaged var completed: Bool
    @NSManaged var createdAt: Data?
    @NSManaged var dueDate: Data?
    @NSManaged var imageURL: URL
    @NSManaged var data: Data?
    @NSManaged var cache: ManagedCache
    
    @NSManaged var dependentTasks: NSOrderedSet?
}

// MARK: - Local Representation
extension ManagedTodoItem {
    var local: LocalTodoItem {
        var dependenciesIDs: [UUID] = []
        
        if let dependenciesSet = dependentTasks,
           let dependenciesArray = dependenciesSet.array as? [ManagedTodoDependency] {
            dependenciesIDs = dependenciesArray.compactMap { $0.id }
        }
        
        return LocalTodoItem(
            id: id,
            title: decryptedTitle(),
            description: decryptedDescription(),
            completed: completed,
            createdAt: decryptedCreatedDate(),
            dueDate: decryptedDueDate(),
            imageURL: imageURL,
            dependencies: dependenciesIDs
        )
    }
    
    private func decryptedTitle() -> String {
        return (ManagedTodoItem.decryptTodoItemString(title ?? Data())) ?? ""
    }
    
    private func decryptedDescription() -> String {
        return (ManagedTodoItem.decryptTodoItemString(todoDescription ?? Data())) ?? ""
    }
    
    private func decryptedCreatedDate() -> Date {
        return (ManagedTodoItem.decryptTodoItemDate(createdAt ?? Data())) ?? Date()
    }
    
    private func decryptedDueDate() -> Date {
        return (ManagedTodoItem.decryptTodoItemDate(dueDate ?? Data())) ?? Date()
    }
}

// MARK: - Fetching Cache
extension ManagedTodoItem {
    
    static func fetchExistingTasksByID(in context: NSManagedObjectContext) throws -> [UUID: ManagedTodoItem] {
        let request = NSFetchRequest<ManagedTodoItem>(entityName: "ManagedTodoItem")
        request.returnsObjectsAsFaults = false
        let tasks = try context.fetch(request)
        
        return tasks.reduce(into: [UUID: ManagedTodoItem]()) { result, task in
            result[task.id] = task
        }
    }
    
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedTodoItem? {
        guard let entityName = entity().name else {  return nil }
        let request = NSFetchRequest<ManagedTodoItem>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedTodoItem.imageURL), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}

// MARK: - Inserting Cache
extension ManagedTodoItem {
    static func createBatch(
        from localTasks: [LocalTodoItem],
        in context: NSManagedObjectContext,
        with cache: ManagedCache
    ) throws -> [ManagedTodoItem] {
        return  try localTasks.map { local in
            let managedTodo = ManagedTodoItem(context: context)
            managedTodo.id = local.id
            managedTodo.title = ManagedTodoItem.encryptTodoItemString(local.title)
            managedTodo.todoDescription = ManagedTodoItem.encryptTodoItemString(local.description)
            managedTodo.completed = local.completed
            managedTodo.createdAt = ManagedTodoItem.encryptTodoItemDate(local.createdAt)
            managedTodo.dueDate = ManagedTodoItem.encryptTodoItemDate(local.dueDate)
            managedTodo.imageURL = local.imageURL
            managedTodo.dependentTasks = try createBatchManagedDependencies(from: local, in: context)
            
            return managedTodo
        }
    }
    
    private static func createBatchManagedDependencies(
        from localTask: LocalTodoItem,
        in context: NSManagedObjectContext
    ) throws -> NSOrderedSet? {
        let taskDependencies = NSMutableOrderedSet()
        
        for localDependencyId in localTask.dependencies {
            let managedDependency = ManagedTodoDependency(context: context)
            managedDependency.id = localDependencyId
            
            taskDependencies.add(managedDependency)
        }
        
        return taskDependencies.copy() as? NSOrderedSet
    }
}

// MARK: - Updating Cache
extension ManagedTodoItem {
    static func update(
        _ managedTodo: ManagedTodoItem,
        with task: LocalTodoItem,
        in contexnt: NSManagedObjectContext
    ) throws {
        managedTodo.id = task.id
        managedTodo.title = ManagedTodoItem.encryptTodoItemString(task.title)
        managedTodo.todoDescription = ManagedTodoItem.encryptTodoItemString(task.description)
        managedTodo.completed = task.completed
        managedTodo.createdAt = ManagedTodoItem.encryptTodoItemDate(task.createdAt)
        managedTodo.dueDate = ManagedTodoItem.encryptTodoItemDate(task.dueDate)
        managedTodo.imageURL = task.imageURL
        managedTodo.dependentTasks = try createBatchManagedDependencies(from: task, in: contexnt)
    }
}

// MARK: - Data Retrieval
extension ManagedTodoItem {
    static func data(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }
        
        return try first(with: url, in: context)?.data
    }
}

// MARK: - Delete & Cleanup
extension ManagedTodoItem {
    override func prepareForDeletion() {
        super.prepareForDeletion()
        guard let context = managedObjectContext else { return }
        context.userInfo[imageURL] = data
        
        ManagedTodoItem.clearUserInfo(in: context)
    }
    
    // Call this after inserting or deleting objects:
    static func clearUserInfo(in context: NSManagedObjectContext) {
        context.userInfo.removeAllObjects()
    }
}
