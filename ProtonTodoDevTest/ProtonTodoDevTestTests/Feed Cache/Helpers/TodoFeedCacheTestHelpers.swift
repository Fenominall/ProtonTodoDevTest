//
//  TodoFeedCacheTestHelpers.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/18/25.
//

import Foundation
import ProtonTodoDevTest

func uniqueItem(
    title: String = "A title",
    description: String = "A description",
    completed: Bool = false,
    createdAt: Date = Date(),
    dueDate: Date = Date().addingTimeInterval(1000),
    dependencies: [UUID] = []
) -> TodoItem {
    TodoItem(
        id: UUID(),
        title: title,
        description: description,
        completed: completed,
        createdAt: createdAt,
        dueDate: dueDate,
        imageURL: anyURL(),
        dependencies: dependencies
    )
}


func localItem(url: URL) -> LocalTodoItem {
    let item = uniqueLocalItem()
    return LocalTodoItem(
        id: item.id,
        title: item.title,
        description: item.description,
        completed: item.completed,
        createdAt: item.createdAt,
        dueDate: item.dueDate,
        imageURL: url,
        dependencies: item.dependencies
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
