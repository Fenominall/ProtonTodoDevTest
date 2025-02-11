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
    
    @NSManaged var dependencies: Set<ManagedTodoDependency>?
}

// MARK: - Local Representation
extension ManagedTodoItem {
    var local: LocalTodoItem {
        LocalTodoItem(
            id: id,
            title: decryptedTitle(),
            description: decryptedDescription(),
            completed: completed,
            createdAt: decryptedCreatedDate(),
            dueDate: decryptedDueDate(),
            imageURL: imageURL,
            dependencies: []
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
    
    static func fetchExistingTodoIDs(in context: NSManagedObjectContext) throws -> Set<UUID> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedTodoItem.entity().name!)
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["id"]
        
        let results = try context.fetch(request) as? [[String: Any]]
        let ids = results?.compactMap { $0["id"] as? UUID }
        return Set(ids ?? [])
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
    ) -> [ManagedTodoItem] {
        return  localTasks.map { local in
            let managedTodo = ManagedTodoItem(context: context)
            managedTodo.id = local.id
            managedTodo.title = ManagedTodoItem.encryptTodoItemString(local.title)
            managedTodo.todoDescription = ManagedTodoItem.encryptTodoItemString(local.description)
            managedTodo.completed = local.completed
            managedTodo.createdAt = ManagedTodoItem.encryptTodoItemDate(local.createdAt)
            managedTodo.dueDate = ManagedTodoItem.encryptTodoItemDate(local.dueDate)
            managedTodo.imageURL = local.imageURL
            
            return managedTodo
        }
    }
}

// MARK: - Updating Cache
extension ManagedTodoItem {
    static func update(
        _ managedTodo: ManagedTodoItem,
        with task: LocalTodoItem
    ) {
        managedTodo.id = task.id
        managedTodo.title = ManagedTodoItem.encryptTodoItemString(task.title)
        managedTodo.todoDescription = ManagedTodoItem.encryptTodoItemString(task.description)
        managedTodo.completed = task.completed
        managedTodo.createdAt = ManagedTodoItem.encryptTodoItemDate(task.createdAt)
        managedTodo.dueDate = ManagedTodoItem.encryptTodoItemDate(task.dueDate)
        managedTodo.imageURL = task.imageURL
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
