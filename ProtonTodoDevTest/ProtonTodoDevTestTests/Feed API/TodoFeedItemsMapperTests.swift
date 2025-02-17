//
//  TodoFeedItemsMapperTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/17/25.
//

import XCTest
import ProtonTodoDevTest

class TodoFeedItemsMapperTests: XCTestCase {
    
    // MARK: - Helpers
    private func makeItem(
        id: UUID,
        title: String,
        description: String,
        completed: Bool,
        createdAt: Date,
        dueDate: Date,
        imageURL: URL,
        dependencies: [UUID]
    ) -> (model: TodoItem, json: [String: Any]) {
        let item = TodoItem(
            id: id,
            title: title,
            description: description,
            completed: completed,
            createdAt: createdAt,
            dueDate: dueDate,
            imageURL: imageURL,
            dependencies: dependencies
        )
        
        let json = [
            "id": id.uuidString,
            "title": title,
            "description": description,
            "completed": completed,
            "createdAt": createdAt,
            "dueDate": dueDate,
            "imageURL": imageURL.absoluteString,
            "dependencies": dependencies.map { $0.uuidString }
        ].compactMapValues { $0 }
        return (item, json )
    }
}
