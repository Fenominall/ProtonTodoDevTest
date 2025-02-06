//
//  TodoFeedLoader.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol TodoFeedLoader {
    func load() async throws -> [TodoItem]
}
