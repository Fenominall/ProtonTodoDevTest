//
//  TodoFeedStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol TodoFeedStore {
    func retrieve() async throws -> [LocalTodoItem]
    func insert(_ feed: [LocalTodoItem]) async throws
    func update(_ item: [LocalTodoItem]) async throws
}
