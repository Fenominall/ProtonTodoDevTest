//
//  CoreDataFeedStore+TodoFeedimageStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

extension CoreDataFeedStore: TodoFeedImageStore {
    public func cache(_ data: Data, for url: URL) async throws {
        // TODO
    }
    
    public func retrieve(from url: URL) async throws -> Data? {
        // TODO
        Data()
    }
}
