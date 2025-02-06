//
//  TodoItemSaveable.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

protocol TodoItemSaveable {
    func save(_ item: TodoItem) async throws
}
