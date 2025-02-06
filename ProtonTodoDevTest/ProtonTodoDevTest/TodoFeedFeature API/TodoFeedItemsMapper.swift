//
//  TodoFeedItemsMapper.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public final class TodoFeedItemsMapper {
    
    private struct Root: Codable {
        private let tasks: [RemoteTodoItem]
        
        private struct RemoteTodoItem: Codable {
            let id: UUID
            let title: String
            let description: String
            var completed: Bool
            let createdAt: Date
            let dueDate: Date
            let imageURL: URL?
        }
        
        var items: [TodoItem] {
            tasks.map {
                TodoItem(
                    id: $0.id,
                    title: $0.title,
                    description: $0.description,
                    completed: $0.completed,
                    createdAt: $0.createdAt,
                    dueDate: $0.dueDate,
                    imageURL: $0.imageURL
                )
            }
        }
    }
    
    private enum Error: Swift.Error {
        case invalidResponse
    }
    
    private static let decoder = JSONDecoder()
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [TodoItem] {
        guard response.isStatusOK else {
            throw Error.invalidResponse
        }
        let root = try decoder.decode(Root.self, from: data)
        
        return root.items
    }
}
