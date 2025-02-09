//
//  CoreDataFeedStore+TodoFeedimageStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

extension CoreDataFeedStore: TodoFeedImageStore {
    public func cache(_ data: Data, for url: URL) async throws {
        try await performAsync { context in
            try ManagedTodoItem.first(with: url, in: context)
                .map { $0.data = data }
                .map(context.save)
        }
    }
    
    public func retrieve(from url: URL) async throws -> Data? {
        try await performAsync { context in
            return try ManagedTodoItem.data(with: url, in: context)
        }
    }
}
