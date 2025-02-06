//
//  CoreDataFeedStore+TodoFeedStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import CoreData

extension CoreDataFeedStore: TodoFeedStore {
    public func retrieve() async throws -> [LocalTodoItem] {
        // TODO
        []
    }
    
    public func insert(_ feed: [LocalTodoItem]) async throws {
        // TODO
    }
    
    public func update(_ item: LocalTodoItem) async throws {
        // TODO
    }
}
