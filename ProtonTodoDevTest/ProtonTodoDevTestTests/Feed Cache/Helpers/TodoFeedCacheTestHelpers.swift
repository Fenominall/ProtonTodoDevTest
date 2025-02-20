//
//  TodoFeedCacheTestHelpers.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/18/25.
//

import Foundation
import ProtonTodoDevTest

func uniqueItem() -> TodoItem {
    TodoItem(
        id: UUID(),
        title: "A title",
        description: "A description",
        completed: false,
        createdAt: Date(),
        dueDate: Date().addingTimeInterval(1000),
        imageURL: anyURL(),
        dependencies: [UUID()]
    )
}

func uniqueLocalItem() -> LocalTodoItem {
    LocalTodoItem(
        id: UUID(),
        title: "A title",
        description: "A description",
        completed: false,
        createdAt: Date(),
        dueDate: Date().addingTimeInterval(1000),
        imageURL: anyURL(),
        dependencies: [UUID()]
    )
}

func uniqueTodoItems() -> (models: [TodoItem], local: [LocalTodoItem]) {
    let item1 = makeItem(id: UUID(), dependencies: [])
    let item2 = makeItem(id: UUID(), dependencies: [item1.model.id])
    let feed = [item1.model, item2.model]
    
    let localTodoItems = feed.map {
        LocalTodoItem(
            id: $0.id,
            title: $0.title,
            description: $0.description,
            completed: $0.completed,
            createdAt: $0.createdAt,
            dueDate: $0.dueDate,
            imageURL: $0.imageURL,
            dependencies: $0.dependencies
        )
    }
    
    return (feed, localTodoItems)
}
