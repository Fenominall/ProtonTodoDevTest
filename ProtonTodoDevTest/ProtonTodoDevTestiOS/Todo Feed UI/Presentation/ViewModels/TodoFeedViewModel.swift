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
    
    private var originalFilteredItems = ThreadSafeArray<TodoItem>()
    private var originalFilteredItemsDictionary = ThreadSafeDictionary<UUID, Int>()
    
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
        print("CREATED TodoFeedViewModel")
        print("TodoFeedViewModel INIT - ObjectIdentifier: \(ObjectIdentifier(self).hashValue)")
    }
}

// MARK: - Load Feed & Pass Selected Model to Open Todo Detail View
extension TodoFeedViewModel {
    /// Loading TodoItems from the API
    @MainActor
    func load() {
        print("CALLED LOAD and assigned data to tasks in TodoFeedViewModel")
        print("TodoFeedViewModel INIT - ObjectIdentifier: \(ObjectIdentifier(self).hashValue)")
        guard !isLoading else {
            return }
        
        isLoading = true
        
        Task {
            do {
                let items = try await loadFeed()
                
                let updatedOriginalItems = await addOrOriginalUpdateTasks(items)
                let filteredOriginalItems = await filterTasks(with: updatedOriginalItems)
                let updatedOriginalFilteredItems = await addOrUpdateOriginalFilteredTasks(filteredOriginalItems)
                
                isLoading = false
                tasks = updatedOriginalFilteredItems.mapToViewRepresentationModel()
            } catch {
                isLoading = false
                todoFeedError = .networkError
            }
        }
    }
    
    /// Used to find a TodoItem by the selected index on order to provide for composing the TodoItemDetailViewComposer
    func selectItem(with id: UUID) async {
        guard let todo = await getOriginalTodoItem(byID: id) else { return }
        print("Called selectItem in TodoFeedViewModel")
        print("TodoFeedViewModel INIT - ObjectIdentifier: \(ObjectIdentifier(self).hashValue)")
        selection(todo)
    }
}

// MARK: - Checking tasks dpendencies for TodoItem status completion
extension TodoFeedViewModel {
    public func toggleTaskCompletion(withID id: UUID) async -> Bool {
        print("CALLED toggleTaskCompletion method in toggleTaskCompletion")
        print("TodoFeedViewModel INIT - ObjectIdentifier: \(ObjectIdentifier(self).hashValue)")
        await print(originalItemsDictionary.count)
        await print(originalItems.count)
        guard var originalTodo = await getOriginalTodoItem(byID: id),
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
        // Updating Filtered items array with the DTO array
        guard var originalFilteredTodo = await getOriginalFilteredTodoItem(byID: model.id),
              let todoFilteredDTOIndex = await originalFilteredItemsDictionary[model.id] else {
            return false
        }
        
        await MainActor.run {
            tasks[todoFilteredDTOIndex].completed = isCompleted
        }
        originalFilteredTodo.completed = isCompleted
        
        // Updating original items and saving changes in the local storage
        model.completed = isCompleted
        await originalItems.update(at: index, with: model)
        taskToUpdate(model)
        return isCompleted
    }
}

// MARK: - Find and check Taask Finished dependencies check algorithm
extension TodoFeedViewModel {
    private func canFinishCheckWith(
        id: UUID,
        in todos: ThreadSafeArray<TodoItem>,
        visited: inout Set<UUID>
    ) async -> Bool {
        if visited.contains(id) {
            return false
        }
        
        guard let task = await getOriginalTodoItem(byID: id) else {
            return false
        }
        
        if task.completed {
            return true
        }
        
        visited.insert(id)
        
        for dependencyID in task.dependencies {
            guard let depTask = await getOriginalTodoItem(byID: dependencyID) else {
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
}

// MARK: - Find unfinished todo dependecnies and generate a String of unfinished tasks
extension TodoFeedViewModel {
    private func getListOfNotFinishedDependencies(
        id: UUID,
        in todos: ThreadSafeArray<TodoItem>,
        visited: inout Set<UUID>
    ) async -> String? {
        var unfinishedDependencies = Set<String>()
        
        if visited.contains(id) {
            guard let todoToAdd = await getOriginalTodoItem(byID: id) else {
                return nil
            }
            unfinishedDependencies.insert(todoToAdd.title)
            return unfinishedDependencies.joined(separator: ", ")
        }
        
        guard let todo = await getOriginalTodoItem(byID: id) else {
            return nil
        }
        
        visited.insert(id)
        
        for dependencyID in todo.dependencies {
            guard let depTodo = await getOriginalTodoItem(byID: dependencyID) else {
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

// MARK: - Filtering & Items Look up for Picking a necessaey task
extension TodoFeedViewModel {
    private func filterTasks(with tasks: [TodoItem]) async -> [TodoItem] {
        tasksFilter(tasks)
    }
    
    private func getTodoItem(
        byID id: UUID,
        fromArray array: ThreadSafeArray<TodoItem>,
        withDictionary dictionary: ThreadSafeDictionary<UUID, Int>
    ) async -> TodoItem? {
        guard let index = await originalItemsDictionary[id],
              let task = await originalItems.get(at: index) else {
            return nil
        }
        
        return task
    }
    
    private func getOriginalTodoItem(byID id: UUID) async -> TodoItem? {
        return await getTodoItem(
            byID: id,
            fromArray: originalItems,
            withDictionary: originalItemsDictionary
        )
    }
    
    private func getOriginalFilteredTodoItem(byID id: UUID) async -> TodoItem? {
        return await getTodoItem(
            byID: id,
            fromArray: originalFilteredItems,
            withDictionary: originalFilteredItemsDictionary
        )
    }
}

// MARK: - Updating Data Source with Feed
extension TodoFeedViewModel {
    private func addOrUpdateTasks(
        _ tasks: [TodoItem],
        inArray array: ThreadSafeArray<TodoItem>,
        withDictionary dictionary: ThreadSafeDictionary<UUID, Int>
    ) async -> [TodoItem] {
        for task in tasks where await dictionary[task.id] == nil {
            let currentCount = await array.count
            await array.append(task)
            await dictionary.setValue(currentCount, forKey: task.id)
        }
        
        for task in tasks {
            if let index = await dictionary[task.id] {
                await array.update(at: index, with: task)
            }
        }
        
        let sortedTasks = await array.getAllElements()
        print("Called addOrUpdateTasks in TodoFeedViewModel")
        print("TodoFeedViewModel INIT - ObjectIdentifier: \(ObjectIdentifier(self).hashValue)")
        print(await originalItems.count)
        print(await originalItemsDictionary.count)
        return sortedTasks
    }
    
    private func addOrOriginalUpdateTasks(
        _ tasks: [TodoItem]
    ) async -> [TodoItem] {
        return await addOrUpdateTasks(
            tasks,
            inArray: originalItems,
            withDictionary: originalItemsDictionary
        )
    }
    
    private func addOrUpdateOriginalFilteredTasks(_ tasks: [TodoItem]) async -> [TodoItem] {
        return await addOrUpdateTasks(
            tasks,
            inArray: originalFilteredItems,
            withDictionary: originalFilteredItemsDictionary
        )
    }
}

// MARK: - Transftorming Helper
extension Array where Element == TodoItem {
    func mapToViewRepresentationModel() -> [TodoItemPresentationModel] {
        return map {
            TodoItemPresentationModel(from: $0)
        }
    }
}
