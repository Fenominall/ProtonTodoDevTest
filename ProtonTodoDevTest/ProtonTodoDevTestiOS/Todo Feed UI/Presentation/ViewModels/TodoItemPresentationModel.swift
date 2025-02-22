//
//  TodoItemViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import ProtonTodoDevTest

public struct TodoItemPresentationModel: Identifiable, Hashable {
    public let id: UUID
    public let title: String
    public let description: String
    public var completed: Bool
    public let createdAt: Date
    public let dueDate: Date
    public let imageURL: URL
    public var imageData: Data?
    public var dependencies: [UUID]
    
    init(
        id: UUID,
        title: String,
        description: String,
        completed: Bool,
        createdAt: Date,
        dueDate: Date,
        imageURL: URL,
        imageData: Data?,
        dependencies: [UUID]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.completed = completed
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.imageURL = imageURL
        self.imageData = imageData
        self.dependencies = dependencies
    }
    
    public init(from item: TodoItem) {
        self.id = item.id
        self.title = item.title
        self.description = item.description
        self.completed = item.completed
        self.createdAt = item.createdAt
        self.dueDate = item.dueDate
        self.imageURL = item.imageURL
        self.imageData = nil
        self.dependencies = item.dependencies
    }
    
    // MARK: - Helpers
    var createdAtString: String {
        createdAt.iso8601FormattedString()
    }
    
    var dueDateString: String {
        dueDate.iso8601FormattedString()
    }
}
