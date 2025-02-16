//
//  ContentView.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI
import Combine
import ProtonTodoDevTest
import ProtonTodoDevTestiOS

struct AppTabView: View {
    let feedLoader: () -> AnyPublisher<[TodoItem], Error>
    let imageLoader: (URL) -> TodoImageLoader.Publisher
    let todoItemSaveable: TodoItemSaveable
    
    init(
        feedLoader: @escaping () -> AnyPublisher<[TodoItem], Error>,
        imageLoader: @escaping (URL) -> TodoImageLoader.Publisher,
        todoItemSaveable: TodoItemSaveable
    ) {
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
        self.todoItemSaveable = todoItemSaveable
    }
    
    
    var body: some View {
        Text("Proton Test")
            .font(.largeTitle)
        TabView {
            TodoTabCoordinator(
                title: "All tasks",
                feedLoader: feedLoader,
                imageLoader: imageLoader,
                todoItemSaveable: todoItemSaveable,
                tasksFilter: { tasks in
                    TasksFilteringManager
                        .sortTasksAndFilterByPredicate(tasks) { $0.createdAt > $1.createdAt }
                })
            .tabItem {
                Label(
                    "All Tasks",
                    systemImage: AppImageConsntants.house.rawValue
                )
            }
            
            TodoTabCoordinator(
                title: "Upcoming Tasks",
                feedLoader: feedLoader,
                imageLoader: imageLoader,
                todoItemSaveable: todoItemSaveable,
                tasksFilter: TasksFilteringManager
                    .filterUpcomingTasksByDependencies
            )
            .tabItem {
                Label(
                    "Upcoming Tasks",
                    systemImage: AppImageConsntants.calendar.rawValue
                )
            }
        }
    }
}
