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
    private let selection: (TodoItem) -> Void
    private let todoStatusChaged: (TodoItem) -> Void
    
    private var originalItems = ThreadSafeArray<TodoItem>()
    private var originalItemsDictionary = ThreadSafeDictionary<UUID, Int>()
    
    // MARK: - Initializer
    public init(loadFeed: @escaping () async throws -> [TodoItem],
                selection: @escaping (TodoItem) -> Void,
                todoStatusChaged: @escaping (TodoItem) -> Void
    ) {
        self.loadFeed = loadFeed
        self.selection = selection
        self.todoStatusChaged = todoStatusChaged
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
                
                await MainActor.run {
                    self.tasks = items.mapToViewRepresentationModel()
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
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
    
    func selectItem(with id: UUID) async {
        if let index = await originalItemsDictionary[id],
           let item = await originalItems.get(at: index) {
            selection(item)
        }
    }
    
    func updateTodoStatus(withID id: UUID, isCompleted status: Bool) async {
        if let index = await originalItemsDictionary[id],
           var item = await originalItems.get(at: index) {
            
            item.completed = status
            await addOrUpdateTasks([item])
            
            todoStatusChaged(item)
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
