//
//  TodoListDestination.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/14/25.
//

import Foundation
import SwiftUI
import ProtonTodoDevTest
import Combine

enum TodoListDestination: Hashable {
    case taskDetails(task: TodoItem)
}

// Represents a module
struct TodoListCoordinator: View {
    @EnvironmentObject private var router: Router
    private let title: String
    private let dependencies: Dependencies
    
    init(title: String, dependencies: Dependencies) {
        self.title = title
        self.dependencies = dependencies
        print("CREATED TodoListCoordinator")
    }
    
    var body: some View {
        TodoListViewComposer.composedViewWith(
            title: title,
            feedLoader: dependencies.feedLoader,
            imageLoader: dependencies.imageLoader,
            todoItemSaveable: dependencies.todoItemSaveable,
            tasksFilter: dependencies.tasksFilter,
            selection: { task in
                Task.detached(priority: .userInitiated) {
                    await router.navigate(to: TodoListDestination.taskDetails(task: task))
                }
            }
        )
        .navigationDestination(for: TodoListDestination.self) { destination in
            switch destination {
            case let .taskDetails(task):
                TodoDetailViewComposer.composedViewWith(
                    item: task,
                    imageLoader: dependencies.imageLoader
                )
            }
        }
    }
}

extension TodoListCoordinator {
    struct Dependencies {
        let feedLoader: () -> AnyPublisher<[TodoItem], Error>
        let imageLoader: (URL) -> TodoImageLoader.Publisher
        let todoItemSaveable: TodoItemSaveable
        let tasksFilter: ([TodoItem]) -> [TodoItem]
        
        public init(
            feedLoader: @escaping () -> AnyPublisher<[TodoItem], Error>,
            imageLoader: @escaping (URL) -> TodoImageLoader.Publisher,
            todoItemSaveable: TodoItemSaveable,
            tasksFilter: @escaping ([TodoItem]) -> [TodoItem]
        ) {
            self.feedLoader = feedLoader
            self.imageLoader = imageLoader
            self.todoItemSaveable = todoItemSaveable
            self.tasksFilter = tasksFilter
        }
    }
}
