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
    public let imageURL: URL?
    
    public init(from item: TodoItem) {
        self.id = item.id
        self.title = item.title
        self.description = item.description
        self.completed = item.completed
        self.createdAt = item.createdAt
        self.dueDate = item.dueDate
        self.imageURL = item.imageURL
    }
    
    // MARK: - Helpers
    var createdAtString: String {
        iso8601FormattedString(from: createdAt)
    }
    
    var dueDateString: String {
        iso8601FormattedString(from: dueDate)
    }
}
