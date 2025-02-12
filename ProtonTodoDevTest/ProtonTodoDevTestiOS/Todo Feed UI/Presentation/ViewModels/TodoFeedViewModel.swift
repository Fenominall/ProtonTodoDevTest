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
    @Published var error: String?
    
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
                await addOrUpdateTasks(items)
                let filteredTasks = await filterTasks(with: items)
                await MainActor.run {
                    self.isLoading = false
                    self.tasks = filteredTasks.mapToViewRepresentationModel()
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.error = error.localizedDescription
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
                boolToReturn: false
            )
        } else if await canFinishTask(id: id, in: originalItems) {
            return await updateTodoItemsAfterCheckWith(
                index: todoDTOIndex,
                for: &originalTodo,
                boolToReturn: true
            )
        } else {
            return await updateTodoItemsAfterCheckWith(
                index: todoDTOIndex,
                for: &originalTodo,
                boolToReturn: false
            )
        }
    }
    
    private func updateTodoItemsAfterCheckWith(
        index: Int,
        for model: inout TodoItem,
        boolToReturn: Bool
    ) async -> Bool {
        await MainActor.run {
            tasks[index].completed = boolToReturn
        }
        model.completed = boolToReturn
        await originalItems.update(at: index, with: model)
        taskToUpdate(model)
        return boolToReturn
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
}

extension Array where Element == TodoItem {
    func mapToViewRepresentationModel() -> [TodoItemPresentationModel] {
        return map {
            TodoItemPresentationModel(from: $0)
        }
    }
}
