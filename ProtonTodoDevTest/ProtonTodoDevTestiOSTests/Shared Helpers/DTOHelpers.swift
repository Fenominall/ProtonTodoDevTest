//
//  DTOHelpers.swift
//  ProtonTodoDevTestiOSTests
//
//  Created by Fenominall on 2/20/25.
//

import Foundation
@testable import ProtonTodoDevTestiOS

func anyPresentationModel(
    id: UUID = UUID(),
    title: String = "Task",
    description: String = "Description",
    completed: Bool = false,
    createdAt: Date = Date(),
    dueDate: Date = Date().addingTimeInterval(86400),
    imageURL: URL = URL(string: "https://example.com")!,
    imageData: Data? = nil,
    dependencies: [UUID] = []
) -> TodoItemPresentationModel {
    TodoItemPresentationModel(
        id: id,
        title: title,
        description: description,
        completed: completed,
        createdAt: createdAt,
        dueDate: dueDate,
        imageURL: imageURL,
        imageData: imageData,
        dependencies: dependencies
    )
}
