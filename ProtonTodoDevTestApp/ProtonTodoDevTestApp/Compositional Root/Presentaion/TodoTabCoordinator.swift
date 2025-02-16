//
//  TodoTabCoordinator.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/14/25.
//

import Foundation
import SwiftUI
import ProtonTodoDevTest
import Combine

struct TodoTabCoordinator: View {
    @StateObject private var router = Router()
    private let title: String
    private let feedLoader: () -> AnyPublisher<[TodoItem], Error>
    private let imageLoader: (URL) -> AnyPublisher<Data,Error>
    private let todoItemSaveable: TodoItemSaveable
    private let tasksFilter: ([TodoItem]) -> [TodoItem]
    
    init(title: String,
         feedLoader: @escaping () -> AnyPublisher<[TodoItem], Error>,
         imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
         todoItemSaveable: TodoItemSaveable,
         tasksFilter: @escaping ([TodoItem]) -> [TodoItem]
    ) {
        self.title = title
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
        self.todoItemSaveable = todoItemSaveable
        self.tasksFilter = tasksFilter
        print("CREATED TodoTabCoordinator")
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            TodoListCoordinator(
                title: title,
                dependencies: .init(
                    feedLoader: feedLoader,
                    imageLoader: imageLoader,
                    todoItemSaveable: todoItemSaveable,
                    tasksFilter: tasksFilter
                )
            )
        }
        .environmentObject(router)
    }
}
