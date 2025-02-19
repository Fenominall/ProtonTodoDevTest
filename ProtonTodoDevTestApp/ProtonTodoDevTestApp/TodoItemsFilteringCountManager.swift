//
//  Ts.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/19/25.
//

import Foundation
import Combine
import ProtonTodoDevTest

final class TodoItemsFilteringCountManager: ObservableObject {
    @Published var allTasksCount: Int = 0
    @Published var upcomingTasksCount: Int = 0
    
    private func updateTaksCount<T>(
        tasks: [T],
        tasksFilter: ([T]) -> [T],
        updateTasksCount: @escaping (Int) -> Void
    ) -> [T] {
        let filteredTasks = tasksFilter(tasks)
        
        Task {
            await MainActor.run {
                updateTasksCount(filteredTasks.count)
            }
        }
        
        return filteredTasks
    }
    
    func filterAllTaksAndUpdateAllTasksCount(_ tasks: [TodoItem]) -> [TodoItem] {
        let filteredTasks = updateTaksCount(tasks: tasks) {
            TasksFilteringManager
                .sortTasksAndFilterByPredicate($0) {
                    $0.createdAt > $1.createdAt
                }
        } updateTasksCount: { [weak self] in
            self?.allTasksCount = $0
        }
        
        return filteredTasks
    }
    
    func filterUpcomingTaksAndUpdateupcomingTasksCount(_ tasks: [TodoItem]) -> [TodoItem] {
        let filteredTasks = updateTaksCount(tasks: tasks) {
            TasksFilteringManager
                .filterUpcomingTasksByDependencies($0)
        } updateTasksCount: { [weak self] in
            self?.upcomingTasksCount = $0
        }
        
        return filteredTasks
    }
}
