//
//  FeedCache.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol TodoFeedCache {
    func save(_ feed: [TodoItem]) async throws
}
