//
//  TodoFeedViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine
import ProtonTodoDevTest

public final class TodoFeedViewModel: ObservableObject {
    // MARK: - Properties
    @Published var tasks = [TodoItemPresentationModel]()
    @Published var isLoading: Bool = false
    @Published var todoFeedError: TodoFeedError?
    
    private let loadFeed: () async throws -> [TodoItem]
    private let tasksFilter: ([TodoItem]) -> [TodoItem]
    private let selection: (TodoItem) -> Void
    private let taskToUpdate: (TodoItem) -> Void
    
    
    private var originalItems = ThreadSafeArray<TodoItem>()
    private var originalItemsDictionary = ThreadSafeDictionary<UUID, Int>()
    
    // MARK: - Initializer
    public init(loadFeed: @escaping () async throws -> [TodoItem],
                taskFilter: @escaping ([TodoItem]) -> [TodoItem],
                selection: @escaping (TodoItem) -> Void,
                taskToUpdate: @escaping (TodoItem) -> Void
    ) {
        self.loadFeed = loadFeed
        self.tasksFilter = taskFilter
        self.selection = selection
        self.taskToUpdate = taskToUpdate
    }
    
    // MARK: - Actions
    /// Loading TodoItems from the API
    func load() {
        guard !isLoading else {
            return }
        
        isLoading = true
        
        Task {
            do {
                let items = try await loadFeed()
                let filteredTasks = await filterTasks(with: items)
                await addOrUpdateTasks(items)
                await MainActor.run {
                    self.isLoading = false
                    self.tasks = filteredTasks.mapToViewRepresentationModel()
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.todoFeedError = .networkError
                }
            }
        }
    }
    
    private func addOrUpdateTasks(_ tasks: [TodoItem]) async {
        for task in tasks where await originalItemsDictionary[task.id] == nil {
            let currentCount = await originalItems.count
            await originalItems.append(task)
            await originalItemsDictionary.setValue(currentCount, forKey: task.id)
        }
        
        for task in tasks {
            if let index = await originalItemsDictionary[task.id] {
                await originalItems.update(at: index, with: task)
            }
        }
    }
    
    private func filterTasks(with tasks: [TodoItem]) async -> [TodoItem] {
        tasksFilter(tasks)
    }
    
    /// Used to find a TodoItem by the selected index on order to provide for composing the TodoItemDetailViewComposer
    func selectItem(with id: UUID) async {
        guard let todo = await getTodoItem(byID: id) else { return }
        selection(todo)
    }
    
    // MARK: - Checking tasks dpendencies for TodoItem status completion
    public func toggleTaskCompletion(withID id: UUID) async -> Bool {
        guard var originalTodo = await getTodoItem(byID: id),
              let todoDTOIndex = await originalItemsDictionary[id] else {
            return false
        }
        
        if originalTodo.completed {
            return await updateTodoItemsAfterCheckWith(
                index: todoDTOIndex,
                for: &originalTodo,
                isCompleted: false
            )
        } else if await canFinishTask(id: id, in: originalItems) {
            return await updateTodoItemsAfterCheckWith(
                index: todoDTOIndex,
                for: &originalTodo,
                isCompleted: true
            )
        } else {
            guard let unfinishedDependenciesError = await unfinishedTasks(id: id, in: originalItems) else {
                return false
            }
            await MainActor.run {
                todoFeedError = .unmetDependencies(unfinishedDependenciesError)
            }
            return false
        }
    }
    
    private func updateTodoItemsAfterCheckWith(
        index: Int,
        for model: inout TodoItem,
        isCompleted: Bool
    ) async -> Bool {
        await MainActor.run {
            tasks[index].completed = isCompleted
        }
        model.completed = isCompleted
        await originalItems.update(at: index, with: model)
        taskToUpdate(model)
        return isCompleted
    }
    
    private func canFinishCheckWith(
        id: UUID,
        in todos: ThreadSafeArray<TodoItem>,
        visited: inout Set<UUID>
    ) async -> Bool {
        if visited.contains(id) {
            return false
        }
        
        guard let task = await getTodoItem(byID: id) else {
            return false
        }
        
        if task.completed {
            return true
        }
        
        visited.insert(id)
        
        for dependencyID in task.dependencies {
            guard let depTask = await getTodoItem(byID: dependencyID) else {
                return false
            }
            
            if !depTask.completed {
                return false
            }
            
            if await !canFinishCheckWith(
                id: dependencyID,
                in: todos,
                visited: &visited
            ) {
                return false
            }
        }
        
        return true
    }
    
    private func canFinishTask(
        id: UUID,
        in todos: ThreadSafeArray<TodoItem>
    ) async -> Bool {
        var visited = Set<UUID>()
        
        return await canFinishCheckWith(
            id: id,
            in: todos,
            visited: &visited
        )
    }
    
    private func getTodoItem(byID id: UUID) async -> TodoItem? {
        guard let index = await originalItemsDictionary[id],
              let task = await originalItems.get(at: index) else {
            return nil
        }
        
        return task
    }
    
    private func getListOfNotFinishedDependencies(
        id: UUID,
        in todos: ThreadSafeArray<TodoItem>,
        visited: inout Set<UUID>
    ) async -> String? {
        var unfinishedDependencies = Set<String>()
        
        if visited.contains(id) {
            guard let todoToAdd = await getTodoItem(byID: id) else {
                return nil
            }
            unfinishedDependencies.insert(todoToAdd.title)
            return unfinishedDependencies.joined(separator: ", ")
        }
        
        guard let todo = await getTodoItem(byID: id) else {
            return nil
        }
        
        visited.insert(id)
        
        for dependencyID in todo.dependencies {
            guard let depTodo = await getTodoItem(byID: dependencyID) else {
                continue
            }
            
            if !depTodo.completed {
                unfinishedDependencies.insert(depTodo.title)
            }
            
            if let missingUnfinishedDependencies = await getListOfNotFinishedDependencies(
                id: dependencyID,
                in: todos,
                visited: &visited
            ), !missingUnfinishedDependencies.isEmpty {
                unfinishedDependencies
                    .formUnion(
                        missingUnfinishedDependencies
                            .split(separator: ",\n")
                            .map { String($0) })
            }
        }
        
        return unfinishedDependencies.isEmpty ? nil : unfinishedDependencies.joined(separator: ",\n ")
    }
    
    private func unfinishedTasks(
        id: UUID,
        in todos: ThreadSafeArray<TodoItem>
    ) async -> String? {
        var visited = Set<UUID>()
        
        return await getListOfNotFinishedDependencies(
            id: id,
            in: todos,
            visited: &visited
        )
    }
}

extension Array where Element == TodoItem {
    func mapToViewRepresentationModel() -> [TodoItemPresentationModel] {
        return map {
            TodoItemPresentationModel(from: $0)
        }
    }
}
