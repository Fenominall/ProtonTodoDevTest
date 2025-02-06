//
//  FeedCache.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

protocol TodoFeedCache {
    func save(_ feed: [TodoItem]) async throws
}
