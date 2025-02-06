//
//  TodoItemViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import ProtonTodoDevTest

public struct TodoItemViewModel: Identifiable, Hashable {
    public let id: UUID
    public let title: String
    public let description: String
    public var completed: Bool
    private let createdAt: Date
    private let dueDate: Date
    public let imageData: Data?
    
    init(
        id: UUID,
        title: String,
        description: String,
        completed: Bool,
        createdAt: Date,
        dueDate: Date,
        imageURL: Data?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.completed = completed
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.imageData = imageURL
    }
    
    public init(from item: TodoItem) {
        self.id = item.id
        self.title = item.title
        self.description = item.description
        self.completed = item.completed
        self.createdAt = item.createdAt
        self.dueDate = item.dueDate
        self.imageData = nil
    }
    
    // MARK: - Helpers
    var createdAtString: String {
        iso8601FormattedString(from: createdAt)
    }
    
    var dueDateString: String {
        iso8601FormattedString(from: dueDate)
    }
}
