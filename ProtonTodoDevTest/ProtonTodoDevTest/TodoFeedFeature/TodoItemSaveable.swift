//
//  TodoItemSaveable.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol TodoItemSaveable {
    func save(_ item: TodoItem) async throws
}
