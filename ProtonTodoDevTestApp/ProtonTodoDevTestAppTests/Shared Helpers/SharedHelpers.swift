//
//  SharedHelpers.swift
//  ProtonTodoDevTestAppTests
//
//  Created by Fenominall on 2/21/25.
//

import Foundation
import ProtonTodoDevTest

func anyURL() -> URL {
    URL(string: "https://api-example.com/")!
}

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
        dependencies: [UUID()]
    )
}

