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
    private let createdAt: Date
    private let dueDate: Date
    public let imageURL: URL
    public var imageData: Data?
    
    init(
        id: UUID,
        title: String,
        description: String,
        completed: Bool,
        createdAt: Date,
        dueDate: Date,
        imageURL: URL,
        imageData: Data?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.completed = completed
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.imageURL = imageURL
        self.imageData = imageData
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
    }
    
    // MARK: - Helpers
    var createdAtString: String {
        createdAt.iso8601FormattedString(from: createdAt)
    }
    
    var dueDateString: String {
        dueDate.iso8601FormattedString(from: dueDate)
    }
}
