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
    @StateObject private var filteringManager = TodoItemsFilteringCountManager()
    
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
                tasksFilter: filteringManager
                    .filterAllTaksAndUpdateAllTasksCount
            )
            .tabItem {
                Label(
                    "All Tasks",
                    systemImage: AppImageConstants.house.imageName
                )
            }
            .badge(filteringManager.allTasksCount)
            
            TodoTabCoordinator(
                title: "Upcoming Tasks",
                feedLoader: feedLoader,
                imageLoader: imageLoader,
                todoItemSaveable: todoItemSaveable,
                tasksFilter: filteringManager
                    .filterUpcomingTaksAndUpdateupcomingTasksCount
            )
            .tabItem {
                Label(
                    "Upcoming Tasks",
                    systemImage: AppImageConstants.calendar.imageName
                )
            }
            .badge(filteringManager.upcomingTasksCount)
        }
    }
}
