//
//  SharedExtensionHelpers.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/17/25.
//

import Foundation
import ProtonTodoDevTest

extension Date {
    func iso8601FormattedString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyURL() -> URL {
    URL(string: "https://api-example.com/")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error",
                   code: 1)
}

func makeItemsJSON(_ items: [[String: Any]]) throws -> Data {
    let json = ["tasks": items]
    return try JSONSerialization.data(withJSONObject: json, options: [.sortedKeys])
}

// Mock method to generate TodoItem and corresponding JSON for unit testing
func makeItem(
    id: UUID = UUID(),
    title: String = "Default Task",
    description: String = "Task description",
    completed: Bool = false,
    createdAt: Date = Date(),
    dueDate: Date = Date(),
    imageURL: URL = URL(string: "https://example.com")!,
    dependencies: [UUID] = []
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
    
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    let json: [String: Any] = [
        "id": id.uuidString,
        "title": title,
        "description": description,
        "completed": completed,
        "createdAt": dateFormatter.string(from: createdAt),
        "dueDate": dateFormatter.string(from: dueDate),
        "imageURL": imageURL.absoluteString,
        "dependencies": dependencies.map { $0.uuidString }.sorted()
    ]
    
    return (item, json)
}

