//
//  TodoItem.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

struct TodoItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    var completed: Bool
    let createdAt: Date
    let dueDate: Date
    let imageURL: URL?

    init(
        id: UUID,
        title: String,
        description: String,
        completed: Bool,
        createdAt: Date,
        dueDate: Date,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.completed = completed
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.imageURL = imageURL
    }
}
