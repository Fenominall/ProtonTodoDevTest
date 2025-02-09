//
//  NullStore.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import ProtonTodoDevTest

final class NullStore: TodoFeedStore {
    func retrieve() async throws -> [ProtonTodoDevTest.LocalTodoItem] { [] }
    
    func insert(_ feed: [ProtonTodoDevTest.LocalTodoItem]) async throws {}
    
    func update(_ item: ProtonTodoDevTest.LocalTodoItem) async throws {}
}

extension NullStore: TodoFeedImageStore {
    func cache(_ data: Data, for url: URL) async throws {}
    
    func retrieve(from url: URL) async throws -> Data? { Data() }
}
