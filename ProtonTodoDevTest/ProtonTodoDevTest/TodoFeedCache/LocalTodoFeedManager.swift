//
//  LocalTodoFeedManager.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public final class LocalTodoFeedManager {
    private let store: TodoFeedStore
    
    init(store: TodoFeedStore) {
        self.store = store
    }
}

extension LocalTodoFeedManager: TodoFeedLoader {
    public func load() async throws -> [TodoItem] {
        let items =  try await store.retrieve().convertToModels()
        return items
    }
}

private extension Array where Element == LocalTodoItem {
    func convertToModels() -> [TodoItem] {
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
