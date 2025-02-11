//
//  LocalTodoFeedManager.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public final class LocalTodoFeedManager {
    private let store: TodoFeedStore
    
    public init(store: TodoFeedStore) {
        self.store = store
    }
}

// MARK: - Loading Cache
extension LocalTodoFeedManager: TodoFeedLoader {
    public func load() async throws -> [TodoItem] {
        let items =  try await store.retrieve().convertedToModels()
        return items
    }
}

// MARK: - Saving to Cache
extension LocalTodoFeedManager: TodoFeedCache {
    public func save(_ feed: [TodoItem]) async throws {
        try await store.insert(feed.convertedToLocale())
    }
}

extension LocalTodoFeedManager: TodoItemSaveable {
    public func save(_ item: TodoItem) async throws {
        try await store.update(toLocal(for: item))
    }
    
    private func toLocal(for item: TodoItem) -> LocalTodoItem {
        LocalTodoItem(
            id: item.id,
            title: item.title,
            description: item.description,
            completed: item.completed,
            createdAt: item.createdAt,
            dueDate: item.dueDate,
            imageURL: item.imageURL,
            dependencies: <#[UUID]#>
        )
    }
}

// MARK: - Converting Helper Extensions
private extension Array where Element == LocalTodoItem {
    func convertedToModels() -> [TodoItem] {
        map {
            TodoItem(
                id: $0.id,
                title: $0.title,
                description: $0.description,
                completed: $0.completed,
                createdAt: $0.createdAt,
                dueDate: $0.dueDate,
                imageURL: $0.imageURL
            )
        }
    }
}

private extension Array where Element == TodoItem {
    func convertedToLocale() -> [LocalTodoItem] {
        map {
            LocalTodoItem(
                id: $0.id,
                title: $0.title,
                description: $0.description,
                completed: $0.completed,
                createdAt: $0.createdAt,
                dueDate: $0.dueDate,
                imageURL: $0.imageURL,
                dependencies: <#[UUID]#>
            )
        }
    }
}
