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
    
    private var originalItems = ThreadSafeArray<TodoItem>()
    private var originalItemsDictionary = ThreadSafeDictionary<UUID, Int>()
    
    // MARK: - Initializer
    public init(loadFeed: @escaping () async throws -> [TodoItem],
                taskFilter: @escaping ([TodoItem]) -> [TodoItem],
                selection: @escaping (TodoItem) -> Void
    ) {
        self.loadFeed = loadFeed
        self.tasksFilter = taskFilter
        self.selection = selection
    }
    
    // MARK: - Actions
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
    
    func selectItem(with id: UUID) async {
        if let index = await originalItemsDictionary[id],
           let item = await originalItems.get(at: index) {
            selection(item)
        }
    }
}

extension Array where Element == TodoItem {
    func mapToViewRepresentationModel() -> [TodoItemPresentationModel] {
        return map {
            TodoItemPresentationModel(from: $0)
        }
    }
}
