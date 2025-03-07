//
//  TasksFilteringManager.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/13/25.
//

import Foundation
import ProtonTodoDevTest

actor TasksFilteringManager {
    
    static func filterUpcomingTasksByDependencies(_ items: [TodoItem]) -> [TodoItem] {
        let filteredItems = items.filter { !$0.completed }
        
        var graph: [UUID: [UUID]] = [:]
        var taskMap: [UUID: TodoItem] = [:]
        var visiting: Set<UUID> = []
        var visited: Set<UUID> = []
        var resultStack = [TodoItem]()
        
        for todo in filteredItems {
            graph[todo.id] = todo.dependencies
            taskMap[todo.id] = todo
        }
        
        func dfs(_ taskID: UUID) -> Bool {
            if visiting.contains(taskID) { return false }
            if visited.contains(taskID) { return true }
            
            visiting.insert(taskID)
            
            for depID in graph[taskID] ?? [] {
                if !dfs(depID) { return false }
            }
            
            visiting.remove(taskID)
            visited.insert(taskID)
            
            if let task = taskMap[taskID] {
                resultStack.append(task)
            }
            
            return true
        }
        
        for taskID in filteredItems where !visited.contains(taskID.id) {
            if !dfs(taskID.id) {
                return []
            }
        }
        
        return resultStack
    }
    
    static func sortTasksBy(
        _ items: [TodoItem],
        by preicate: (TodoItem, TodoItem) -> Bool
    ) -> [TodoItem] {
        return items.sorted(by: preicate)
    }
}
