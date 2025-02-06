//
//  CoreDataFeedStore+TodoFeedStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import CoreData

extension CoreDataFeedStore: TodoFeedStore {
    func retrieve() async throws -> [LocalTodoItem] {
        // TODO
        []
    }
    
    func insert(_ feed: [LocalTodoItem]) async throws {
        // TODO
    }
    
    func update(_ item: LocalTodoItem) async throws {
        // TODO
    }
}
