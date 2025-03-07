//
//  CoreDataFeedStore+TodoFeedStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import CoreData

extension CoreDataFeedStore: TodoFeedStore {
    public func retrieve() async throws -> [LocalTodoItem]? {
        try await performAsync { context in
            guard let cache = try ManagedCache.find(in: context) else {
                return nil
            }
            return cache.localFeed
        }
    }
    
    public func insert(_ feed: [LocalTodoItem]) async throws {
        try await performAsync { context in
            try ManagedCache.insert(feed, in: context)
        }
    }
    
    public func update(_ item: LocalTodoItem) async throws {
        try await performAsync { context in
            try ManagedCache.update(item, in: context)
        }
    }
}
