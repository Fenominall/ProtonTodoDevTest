//
//  LocalTodoItem.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public struct LocalTodoItem: Equatable {
    public let id: UUID
    public let title: String
    public let description: String
    public var completed: Bool
    public let createdAt: Date
    public let dueDate: Date
    public let imageURL: URL
    public var dependencies: [UUID]
    
    public init(
        id: UUID,
        title: String,
        description: String,
        completed: Bool,
        createdAt: Date,
        dueDate: Date,
        imageURL: URL,
        dependencies: [UUID]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.completed = completed
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.imageURL = imageURL
        self.dependencies = dependencies
    }
}
